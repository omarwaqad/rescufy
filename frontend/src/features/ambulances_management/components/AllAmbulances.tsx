import SearchBar from "@/shared/common/SearchBar";
import AmbulancesStates from "./AmbulancesStates";
import { AmbulanceCard } from "./AmbulanceCard";
import { AmbulanceFormModal } from "./AmbulanceFormModal";
import { useAmbulances } from "../hooks/useAmbulances";
import { useTranslation } from "react-i18next";

export default function AllAmbulances() {
  const { t } = useTranslation('ambulances');
  const {
    ambulances,
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
  } = useAmbulances();

  return (
    <>
      <div className="my-6">
        <SearchBar
          value={search}
          onSearchChange={setSearch}
          placeholder={t('filters.searchPlaceholder')}
        >
          <AmbulancesStates value={status} onChange={setStatus} />
        </SearchBar>
      </div>

      <main className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6">
        {ambulances.map((ambulance) => (
          <AmbulanceCard
            key={ambulance.id}
            {...ambulance}
            onEdit={() => openEditModal(ambulance)}
          />
        ))}
      </main>

      <button
        onClick={openAddModal}
        className="fixed bottom-8 right-8 rtl:right-auto rtl:left-8 w-14 h-14 rounded-full bg-primary text-white text-xl shadow-lg hover:shadow-xl hover:bg-primary/90 transition-all"
      >
        +
      </button>

      <AmbulanceFormModal
        isOpen={isModalOpen}
        onClose={closeModal}
        onSubmit={submitAmbulance}
        ambulance={selectedAmbulance}
        mode={modalMode}
      />
    </>
  );
}
