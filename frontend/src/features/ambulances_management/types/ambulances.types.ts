export type Ambulance = {
  id: string;
  licensePlate: string;
  hospitalId: string;
  status: "AVAILABLE" | "IN_TRANSIT" | "BUSY" | "MAINTENANCE";
  latitude: number;
  longitude: number;
};
