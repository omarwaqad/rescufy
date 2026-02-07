import { useState, useMemo } from "react";
import { hospitalsData } from "../data/hospitals.data";
import type { Hospital } from "../data/hospitals.data";
import hospitalFilter from "../utils/hospital.filter";

export function useHospitals() {
  const [hospitals, setHospitals] = useState<Hospital[]>(hospitalsData);
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState("all");
  const [modalMode, setModalMode] = useState<"add" | "edit">("add");
  const [selectedHospital, setSelectedHospital] = useState<
    Hospital | undefined
  >();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const filteredHospitals = useMemo(() => {
    return hospitalFilter(hospitals, { search, status });
  }, [hospitals, search, status]);

  const openAddModal = () => {
    setSelectedHospital(undefined);
    setModalMode("add");
    setIsModalOpen(true);
  };

  const openEditModal = (hospital: Hospital) => {
    setSelectedHospital(hospital);
    setModalMode("edit");
    setIsModalOpen(true);
  };

  const closeModal = () => setIsModalOpen(false);

  const submitHospital = (hospital: Hospital) => {
    if (modalMode === "add") {
      setHospitals((prev) => [...prev, hospital]);
      setIsModalOpen(false);
    } else {
      setHospitals((prev) =>
        prev.map((h) => (h.id === hospital.id ? hospital : h)),
      );
      setIsModalOpen(false);
    }
  };

  return {
    hospitals: filteredHospitals,
    search,
    status,
    setSearch,
    setStatus,
    isModalOpen,
    modalMode,
    selectedHospital,
    openAddModal,
    openEditModal,
    closeModal,
    submitHospital,
  };
}
