import { useState, useMemo } from "react";
import { usersData } from "../data/users.data";
import type { User } from "../data/users.data";
import usersFilter from "../utils/users.filter";

export function useUsers() {
  const [users, setUsers] = useState<User[]>(usersData);
  const [search, setSearch] = useState("");
  const [roleId, setRoleId] = useState("all");
  const [modalMode, setModalMode] = useState<"add" | "edit">("add");
  const [selectedUser, setSelectedUser] = useState<User | undefined>();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const filteredUsers = useMemo(() => {
    return usersFilter(users, { search, roleId });
  }, [users, search, roleId]);

  const openAddModal = () => {
    setSelectedUser(undefined);
    setModalMode("add");
    setIsModalOpen(true);
  };

  const openEditModal = (user: User) => {
    setSelectedUser(user);
    setModalMode("edit");
    setIsModalOpen(true);
  };

  const closeModal = () => setIsModalOpen(false);

  const submitUser = (user: User) => {
    if (modalMode === "add") {
      setUsers((prev) => [...prev, user]);
      setIsModalOpen(false);
    } else {
      setUsers((prev) =>
        prev.map((u) => (u.id === user.id ? user : u))
      );
      setIsModalOpen(false);
    }
  };

  return {
    users: filteredUsers,
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
  };
}
