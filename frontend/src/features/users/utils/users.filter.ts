import type { User } from "../types/users.types";

type filters = {
  search: string;
  roleId: string;
};

export default function usersFilter(users: User[], filters: filters) {
  const q = filters.search.trim().toLowerCase();

  return users.filter((u) => {
    const matchSearch =
      !q ||
      u.name.toLowerCase().includes(q) ||
      u.email.toLowerCase().includes(q) ||
      u.id.toLowerCase().includes(q);

    const matchRole = filters.roleId === "all" || u.roleId === filters.roleId;

    return matchSearch && matchRole;
  });
}
