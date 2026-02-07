import { useState, useMemo } from "react";
import { ambulancesData } from "../data/ambulances.data";
import type { Ambulance } from "../data/ambulances.data";
import ambulanceFilter from "../utils/ambulance.filter";

export function useAmbulances() {
  const [ambulances, setAmbulances] = useState<Ambulance[]>(ambulancesData);
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState("all");
  const [modalMode, setModalMode] = useState<"add" | "edit">("add");
  const [selectedAmbulance, setSelectedAmbulance] = useState<
    Ambulance | undefined
  >();
  const [isModalOpen, setIsModalOpen] = useState(false);

  const filteredAmbulances = useMemo(() => {
    return ambulanceFilter(ambulances, { search, status });
  }, [ambulances, search, status]);

  const openAddModal = () => {
    setSelectedAmbulance(undefined);
    setModalMode("add");
    setIsModalOpen(true);
  };

  const openEditModal = (ambulance: Ambulance) => {
    setSelectedAmbulance(ambulance);
    setModalMode("edit");
    setIsModalOpen(true);
  };

  const closeModal = () => setIsModalOpen(false);

  const submitAmbulance = (ambulance: Ambulance) => {
    if (modalMode === "add") {
      setAmbulances((prev) => [...prev, ambulance]);
      setIsModalOpen(false);
    } else {
      setAmbulances((prev) =>
        prev.map((a) => (a.id === ambulance.id ? ambulance : a))
      );
      setIsModalOpen(false);
    }
  };

  return {
    ambulances: filteredAmbulances,
    search,
    status,
    setSearch,
    setStatus,
    isModalOpen,
    modalMode,
    selectedAmbulance,
    openAddModal,
    openEditModal,
    closeModal,
    submitAmbulance,
  };
}
