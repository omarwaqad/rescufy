import AllAmbulances from "../components/AllAmbulances";

export default function AmbulancesManagement() {
  return (
    <>
      <section className="w-full xl:px-12">
        <header>
          <h1 className="text-heading mb-2 text-4xl font-semibold">
            Ambulances Management
          </h1>
          <p className="text-muted text-sm mt-1">
            Manage ambulance information and locations
          </p>
        </header>
        <AllAmbulances />
      </section>
    </>
  );
}
