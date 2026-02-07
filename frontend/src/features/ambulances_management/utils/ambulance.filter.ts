import type { Ambulance } from "../types/ambulances.types";

type filters = {
  status: string;
  search: string;
};

export default function ambulanceFilter(
  ambulances: Ambulance[],
  filters: filters
) {
  const q = filters.search.trim().toLowerCase();

  return ambulances.filter((a) => {
    const matchSearch =
      !q ||
      a.licensePlate.toLowerCase().includes(q) ||
      a.id.toLowerCase().includes(q) ||
      a.hospitalId.toLowerCase().includes(q);

    const matchStatus =
      filters.status === "all" || a.status === filters.status;

    return matchSearch && matchStatus;
  });
}
