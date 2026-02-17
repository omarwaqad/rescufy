import SearchBar from "@/shared/common/SearchBar";
import UsersRoles from "./UsersRoles";
import { UserRow } from "./UserRow";
import { UserFormModal } from "./UserFormModal";
import { useUsers } from "../hooks/useUsers";
import { useTranslation } from "react-i18next";

export default function AllUsers() {
  const { t } = useTranslation('users');
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
          placeholder={t('filters.searchPlaceholder')}
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
              {t('table.name')}
            </p>
          </div>
          <div className="w-85">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider">
              {t('table.email')}
            </p>
          </div>
          <div className="w-30">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider">
              {t('form.password')}
            </p>
          </div>
          <div className="w-40">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider text-center">
              {t('table.role')}
            </p>
          </div>
          <div className="w-20 text-right rtl:text-left">
            <p className="text-xs font-semibold text-muted uppercase tracking-wider">
              {t('table.actions')}
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
              <p className="text-muted text-sm">{t('empty.title')}</p>
            </div>
          )}
        </div>
      </main>

      <button
        onClick={openAddModal}
        className="fixed bottom-8 right-8 rtl:right-auto rtl:left-8 w-14 h-14 rounded-full bg-primary text-white text-xl shadow-lg hover:shadow-xl hover:bg-primary/90 transition-all"
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
