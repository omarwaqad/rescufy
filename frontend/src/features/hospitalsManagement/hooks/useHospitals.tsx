import { useState, useCallback, useEffect, useMemo } from "react";
import type { Hospital } from "../types/hospitals.types";
import { useGetHospitals } from "./useGetHospitals";
import { useAddHospital } from "./useAddHospital";
import { useUpdateHospital } from "./useUpdateHospital";
import { useDeleteHospital } from "./useDeleteHospital";
import { resolveHospitalLoad, type HospitalLoadStatus } from "../utils/hospital.metrics";

export type HospitalSortOption = "criticalFirst" | "occupancyHigh" | "availableHigh";

export type OperationalHospital = Hospital & {
  usedBeds: number;
  occupancyPercent: number;
  status: HospitalLoadStatus;
};

function sortHospitals(
  items: OperationalHospital[],
  sortOption: HospitalSortOption,
): OperationalHospital[] {
  const sorted = [...items];

  if (sortOption === "occupancyHigh") {
    return sorted.sort((a, b) => b.occupancyPercent - a.occupancyPercent);
  }

  if (sortOption === "availableHigh") {
    return sorted.sort((a, b) => b.availableBeds - a.availableBeds);
  }

  const statusRank: Record<HospitalLoadStatus, number> = {
    CRITICAL: 0,
    FULL: 1,
    BUSY: 2,
    NORMAL: 3,
  };

  return sorted.sort((a, b) => {
    const rankDiff = statusRank[a.status] - statusRank[b.status];
    if (rankDiff !== 0) {
      return rankDiff;
    }

    return b.occupancyPercent - a.occupancyPercent;
  });
}

export function useHospitals() {
  const [modalMode, setModalMode] = useState<"add" | "edit">("add");
  const [selectedHospital, setSelectedHospital] = useState<Hospital | undefined>();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [hospitals, setHospitals] = useState<Hospital[]>([]);
  const [usesServerPagination, setUsesServerPagination] = useState(false);
  const [serverTotalPages, setServerTotalPages] = useState(1);

  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(20);
  const [statusFilter, setStatusFilter] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");
  const [sortOption, setSortOption] = useState<HospitalSortOption>("criticalFirst");

  const { isLoading: isFetchLoading, fetchHospitals } = useGetHospitals();
  const { addHospital, isLoading: isAddLoading } = useAddHospital();
  const { updateHospital, isLoading: isUpdateLoading } = useUpdateHospital();
  const { deleteHospital, isLoading: isDeleteLoading } = useDeleteHospital();

  const applyFetchResult = useCallback(
    (result: Awaited<ReturnType<typeof fetchHospitals>>) => {
      setHospitals(result.hospitals);
      setUsesServerPagination(result.usesServerPagination);

      if (result.usesServerPagination) {
        setServerTotalPages(result.totalPages);
      }
    },
    [],
  );

  const loadHospitals = useCallback(async () => {
    const result = await fetchHospitals(usesServerPagination ? { page, limit } : {});
    applyFetchResult(result);
  }, [applyFetchResult, fetchHospitals, limit, page, usesServerPagination]);

  useEffect(() => {
    void fetchHospitals({}).then(applyFetchResult);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (!usesServerPagination) {
      return;
    }

    void fetchHospitals({ page, limit }).then(applyFetchResult);
  }, [applyFetchResult, fetchHospitals, limit, page, usesServerPagination]);

  const filteredHospitals = useMemo(() => {
    const normalizedSearch = searchQuery.trim().toLowerCase();

    const enriched = hospitals.map((hospital) => {
      const load = resolveHospitalLoad(hospital.availableBeds, hospital.bedCapacity);

      return {
        ...hospital,
        ...load,
      };
    });

    return sortHospitals(
      enriched.filter((hospital) => {
        if (statusFilter !== "all" && hospital.status !== statusFilter) {
          return false;
        }

        if (!normalizedSearch) {
          return true;
        }

        return (
          hospital.name.toLowerCase().includes(normalizedSearch) ||
          hospital.address.toLowerCase().includes(normalizedSearch) ||
          hospital.id.toLowerCase().includes(normalizedSearch)
        );
      }),
      sortOption,
    );
  }, [hospitals, searchQuery, sortOption, statusFilter]);

  const operationalHospitals = useMemo(() => {
    if (usesServerPagination) {
      return filteredHospitals;
    }

    const start = (page - 1) * limit;
    return filteredHospitals.slice(start, start + limit);
  }, [filteredHospitals, limit, page, usesServerPagination]);

  const totalPages = usesServerPagination
    ? serverTotalPages
    : Math.max(1, Math.ceil(filteredHospitals.length / limit));

  const allOperationalHospitals = useMemo(
    () =>
      hospitals.map((hospital) => ({
        ...hospital,
        ...resolveHospitalLoad(hospital.availableBeds, hospital.bedCapacity),
      })),
    [hospitals],
  );

  const handleStatusFilterChange = useCallback((value: string) => {
    setStatusFilter(value);
    setPage(1);
  }, []);

  const handleSearchChange = useCallback((value: string) => {
    setSearchQuery(value);
    setPage(1);
  }, []);

  const handleSortChange = useCallback((value: HospitalSortOption) => {
    setSortOption(value);
    setPage(1);
  }, []);

  const handleLimitChange = useCallback((value: number) => {
    setLimit(value);
    setPage(1);
  }, []);

  const openAddModal = useCallback(() => {
    setSelectedHospital(undefined);
    setModalMode("add");
    setIsModalOpen(true);
  }, []);

  const openEditModal = useCallback((hospital: Hospital) => {
    setSelectedHospital(hospital);
    setModalMode("edit");
    setIsModalOpen(true);
  }, []);

  const closeModal = useCallback(() => {
    setIsModalOpen(false);
    setSelectedHospital(undefined);
  }, []);

  const submitHospital = useCallback(
    async (hospital: Hospital) => {
      if (modalMode === "add") {
        const created = await addHospital(hospital);
        if (created) {
          setIsModalOpen(false);
          setSelectedHospital(undefined);
          await loadHospitals();
        }
      } else if (hospital.id) {
        const updated = await updateHospital(hospital.id, hospital);
        if (updated) {
          setIsModalOpen(false);
          setSelectedHospital(undefined);
          await loadHospitals();
        }
      }
    },
    [modalMode, addHospital, updateHospital, loadHospitals],
  );

  const handleDeleteHospital = useCallback(
    async (hospitalId: string, hospitalName?: string) => {
      const success = await deleteHospital(hospitalId, hospitalName);
      if (success) {
        await loadHospitals();
      }
      return success;
    },
    [deleteHospital, loadHospitals],
  );

  return {
    hospitals: operationalHospitals,
    allHospitals: allOperationalHospitals,
    isModalOpen,
    modalMode,
    selectedHospital,
    isLoading: isFetchLoading || isAddLoading || isUpdateLoading || isDeleteLoading,
    page,
    limit,
    totalPages,
    totalItems: filteredHospitals.length,
    statusFilter,
    searchQuery,
    sortOption,
    setPage,
    setStatusFilter: handleStatusFilterChange,
    setSearchQuery: handleSearchChange,
    setSortOption: handleSortChange,
    setLimit: handleLimitChange,
    openAddModal,
    openEditModal,
    closeModal,
    submitHospital,
    handleDeleteHospital,
  };
}
