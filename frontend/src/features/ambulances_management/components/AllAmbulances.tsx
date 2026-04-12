import SearchBar from "@/shared/common/SearchBar";
import AmbulancesStates from "./AmbulancesStates";
import { AmbulanceCard } from "./AmbulanceCard";
import { AmbulanceFormModal } from "./AmbulanceFormModal";
import { useAmbulances } from "../hooks/useAmbulances";
import { useTranslation } from "react-i18next";
import { motion, useReducedMotion } from "framer-motion";

export default function AllAmbulances() {
  const { t } = useTranslation('ambulances');
  const shouldReduceMotion = useReducedMotion();
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

  const listVariants = {
    hidden: {},
    visible: {
      transition: {
        staggerChildren: shouldReduceMotion ? 0 : 0.08,
        delayChildren: shouldReduceMotion ? 0 : 0.06,
      },
    },
  };

  const itemVariants = {
    hidden: {
      opacity: 0,
      y: shouldReduceMotion ? 0 : 14,
      scale: shouldReduceMotion ? 1 : 0.99,
    },
    visible: {
      opacity: 1,
      y: 0,
      scale: 1,
      transition: {
        duration: shouldReduceMotion ? 0.15 : 0.42,
        ease: [0.22, 1, 0.36, 1] as const,
      },
    },
  };

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

      <motion.main
        className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6"
        variants={listVariants}
        initial="hidden"
        animate="visible"
      >
        {ambulances.map((ambulance) => (
          <motion.div key={ambulance.id} variants={itemVariants}>
            <AmbulanceCard
              {...ambulance}
              onEdit={() => openEditModal(ambulance)}
            />
          </motion.div>
        ))}
      </motion.main>

      <button
        onClick={openAddModal}
        type="button"
        className="fixed bottom-8 right-8 rtl:right-auto rtl:left-8 z-50 w-14 h-14 rounded-full bg-primary text-white text-xl shadow-lg hover:bg-primary/90 transition-colors"
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
