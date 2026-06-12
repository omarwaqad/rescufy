import {
  HubConnection,
  HubConnectionBuilder,
  HubConnectionState,
} from "@microsoft/signalr";
import { getApiUrl } from "@/config/api.config";
import { getAuthToken } from "@/features/auth/utils/auth.utils";

/**
 * SignalR connection singleton and small helpers used by the requests/notifications features.
 *
 * Responsibilities:
 * - Build and start a `HubConnection` to the `/hubs/notifications` endpoint using the current auth token.
 * - Expose small subscription helpers (`onNewRequest`, `onRequestUpdated`, `onNotification`) that
 *   attach to hub events and return an unsubscribe function.
 *
 * Notes:
 * - `startConnection()` is idempotent: it reuses a single `connection` instance and only starts it when disconnected.
 * - Callers should `await startConnection()` before subscribing and always call the returned unsubscribe.
 */

let connection: HubConnection | null = null;
let dispatchConnection: HubConnection | null = null;

export type SignalRConnectionResult = {
  connection: HubConnection | null;
  error: string | null;
};

async function resetDispatchConnection() {
  if (!dispatchConnection) {
    return;
  }

  try {
    await dispatchConnection.stop();
  } catch {
    // Ignore stop errors while resetting a failed connection.
  }

  dispatchConnection = null;
}

function getPayload(event: any): unknown {
  // The server may wrap payloads in different shapes (payload, data, or the event itself).
  if (!event || typeof event !== "object") return event;
  return event.payload ?? event.data ?? event;
}

function getEventType(event: any): string | null {
  // Some notifications include an `eventType` string to multiplex different sub-events.
  if (!event || typeof event !== "object") return null;
  if (typeof event.eventType !== "string") return null;
  return event.eventType.toLowerCase();
}

export async function startConnection(): Promise<HubConnection | null> {
  if (!connection) {
    connection = new HubConnectionBuilder()
      .withUrl(getApiUrl("/hubs/notifications"), {
        // accessTokenFactory will be called by SignalR to acquire the bearer token for the connection.
        accessTokenFactory: () => getAuthToken() ?? "",
      })
      .withAutomaticReconnect()
      .build();
  }

  // Only start if disconnected. This avoids restarting an already-running connection.
  if (connection.state === HubConnectionState.Disconnected) {
    await connection.start();
  }

  return connection;
}

export async function startDispatchConnection(): Promise<SignalRConnectionResult> {
  try {
    if (!dispatchConnection) {
      dispatchConnection = new HubConnectionBuilder()
        .withUrl(getApiUrl("/hubs/dispatch"), {
          // SignalR appends this as `access_token` during negotiate and transport setup.
          accessTokenFactory: () => getAuthToken() ?? "",
        })
        .withAutomaticReconnect()
        .build();
    }

    if (dispatchConnection.state === HubConnectionState.Disconnected) {
      await dispatchConnection.start();
    }

    return { connection: dispatchConnection, error: null };
  } catch (error) {
    console.warn("Dispatch SignalR connection failed:", error);
    await resetDispatchConnection();

    const message =
      error instanceof Error ? error.message : "Failed to connect to dispatch hub";

    return { connection: null, error: message };
  }
}

/**
 * Subscribe to new request events.
 * Attaches both explicit `NewRequest` hub events and the generic `ReceiveNotification` channel
 * where the server may send an `eventType: 'newRequest'` wrapper.
 * Returns an unsubscribe function that callers must invoke on cleanup.
 */
export function onNewRequest(callback: (request: unknown) => void): () => void {
  if (!connection) return () => {};

  const newRequestHandler = (event: unknown) => callback(getPayload(event));

  const notificationHandler = (event: unknown) => {
    const eventType = getEventType(event);
    if (eventType && eventType !== "newrequest") return;
    callback(getPayload(event));
  };

  connection.on("NewRequest", newRequestHandler);
  connection.on("ReceiveNotification", notificationHandler);

  return () => {
    connection?.off("NewRequest", newRequestHandler);
    connection?.off("ReceiveNotification", notificationHandler);
  };
}

/**
 * Subscribe to request updates. Handles both `RequestUpdated` and `StatusChanged` events.
 * Also listens on the generic `ReceiveNotification` channel and filters by `eventType`.
 */
export function onRequestUpdated(callback: (request: unknown) => void): () => void {
  if (!connection) return () => {};

  const requestUpdatedHandler = (event: unknown) => callback(getPayload(event));
  const statusChangedHandler = (event: unknown) => callback(getPayload(event));

  const notificationHandler = (event: unknown) => {
    const eventType = getEventType(event);
    if (eventType !== "requestupdated" && eventType !== "statuschanged") return;
    callback(getPayload(event));
  };

  connection.on("RequestUpdated", requestUpdatedHandler);
  connection.on("StatusChanged", statusChangedHandler);
  connection.on("ReceiveNotification", notificationHandler);

  return () => {
    connection?.off("RequestUpdated", requestUpdatedHandler);
    connection?.off("StatusChanged", statusChangedHandler);
    connection?.off("ReceiveNotification", notificationHandler);
  };
}

/**
 * General-purpose notification subscription. Useful for features that simply want to refresh
 * data when the server signals a change rather than applying a fine-grained patch.
 */
export function onNotification(callback: (event: unknown) => void): () => void {
  if (!connection) return () => {};

  const notificationHandler = (event: unknown) => callback(getPayload(event));

  connection.on("ReceiveNotification", notificationHandler);

  return () => {
    connection?.off("ReceiveNotification", notificationHandler);
  };
}

export function onReceiveRequestEvent(callback: (event: unknown) => void): () => void {
  if (!dispatchConnection) return () => {};

  const handler = (event: unknown) => callback(getPayload(event));

  dispatchConnection.on("ReceiveRequestEvent", handler);

  return () => {
    dispatchConnection?.off("ReceiveRequestEvent", handler);
  };
}

export function onReceiveAlert(callback: (event: unknown) => void): () => void {
  if (!dispatchConnection) return () => {};

  const handler = (event: unknown) => callback(getPayload(event));

  dispatchConnection.on("ReceiveAlert", handler);

  return () => {
    dispatchConnection?.off("ReceiveAlert", handler);
  };
}