import SearchBar from "@/shared/common/SearchBar";
import UsersRoles from "./UsersRoles";
import { UserRow } from "./UserRow";
import { UserFormModal } from "./UserFormModal";
import { useUsers } from "../hooks/useUsers";

export default function AllUsers() {
  const {
    users,
    search,
    roleId,
    setSearch,
    setRoleId,
    isModalOpen,
    modalMode,
    selectedUser,
    openAddModal,
    openEditModal,
    closeModal,
    submitUser,
  } = useUsers();

  return (
    <>
      <div className="my-6">
        <SearchBar
          value={search}
          onSearchChange={setSearch}
          placeholder="Search users by name, email, or ID"
        >
          <UsersRoles value={roleId} onChange={setRoleId} />
        </SearchBar>
      </div>

      <main className="mt-6 border border-border rounded-xl overflow-hidden bg-bg-card">
        {/* Table Header */}
        <div className="hidden md:flex items-center gap-4 px-6 py-4 bg-surface-muted border-b border-border">
          <div className="w-32">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider">
              ID
            </p>
          </div>
          <div className="w-48">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider">
              Name
            </p>
          </div>
          <div className="w-85">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider">
              Email
            </p>
          </div>
          <div className="w-30">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider">
              Password
            </p>
          </div>
          <div className="w-40">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider text-center">
              Role
            </p>
          </div>
          <div className="w-20 text-right">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider">
              Actions
            </p>
          </div>
        </div>

        {/* Rows */}
        <div>
          {users.length > 0 ? (
            users.map((user) => (
              <UserRow
                key={user.id}
                {...user}
                onEdit={() => openEditModal(user)}
              />
            ))
          ) : (
            <div className="flex items-center justify-center py-12">
              <p className="text-muted text-sm">No users found</p>
            </div>
          )}
        </div>
      </main>

      <button
        onClick={openAddModal}
        className="fixed bottom-8 right-8 w-14 h-14 rounded-full bg-primary text-white text-xl shadow-lg hover:shadow-xl hover:bg-primary/90 transition-all"
      >
        +
      </button>

      <UserFormModal
        isOpen={isModalOpen}
        onClose={closeModal}
        onSubmit={submitUser}
        user={selectedUser}
        mode={modalMode}
      />
    </>
  );
}
