import AllUsers from "../components/AllUsers";

export default function Users() {
  return (
    <>
      <section className="w-full xl:px-12">
        <header>
          <h1 className="text-heading mb-2 text-4xl font-semibold">
            Users Management
          </h1>
          <p className="text-muted text-sm mt-1">
            Manage user accounts and role assignments
          </p>
        </header>
        <AllUsers />
      </section>
    </>
  );
}
