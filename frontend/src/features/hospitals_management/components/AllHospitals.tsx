import SearchBar from "@/shared/common/SearchBar";
import HospitalsStates from "./HospitalsStates";
import { HospitalCard } from "./HospitalCard";
import { HospitalFormModal } from "./HospitalFormModal";
import { useHospitals } from "../hooks/useHospitals";
import { useTranslation } from "react-i18next";
import { motion, useReducedMotion } from "framer-motion";

export default function AllHospitals() {
  const { t } = useTranslation('hospitals');
  const shouldReduceMotion = useReducedMotion();
  const {
    hospitals,
    search,
    status,
    setSearch,
    setStatus,
    isModalOpen,
    modalMode,
    selectedHospital,
    isLoading,
    openAddModal,
    openEditModal,
    closeModal,
    submitHospital,
    handleDeleteHospital,
  } = useHospitals();

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
      y: shouldReduceMotion ? 0 : 16,
      scale: shouldReduceMotion ? 1 : 0.99,
    },
    visible: {
      opacity: 1,
      y: 0,
      scale: 1,
      transition: {
        duration: shouldReduceMotion ? 0.15 : 0.45,
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
          <HospitalsStates value={status} onChange={setStatus} />
        </SearchBar>
      </div>

      <motion.main
        className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6"
        variants={listVariants}
        initial="hidden"
        animate="visible"
      >
        {hospitals.length > 0 ? (
          hospitals.map((hospital) => (
            <motion.div key={hospital.id} variants={itemVariants}>
              <HospitalCard
                {...hospital}
                onEdit={() => openEditModal(hospital)}
                onDelete={() => handleDeleteHospital(hospital.id, hospital.name)}
              />
            </motion.div>
          ))
        ) : (
          <div className="col-span-full flex items-center justify-center py-12">
            <p className="text-muted text-sm">
              {isLoading ? t('empty.title') : t('empty.title')}
            </p>
          </div>
        )}
      </motion.main>

      <button
        onClick={openAddModal}
        type="button"
        className="fixed bottom-8 right-8 rtl:right-auto rtl:left-8 z-50 w-14 h-14 rounded-full bg-primary text-white text-xl shadow-lg hover:bg-primary/90 transition-colors"
      >
        +
      </button>

      <HospitalFormModal
        isOpen={isModalOpen}
        onClose={closeModal}
        onSubmit={submitHospital}
        hospital={selectedHospital}
        mode={modalMode}
        isLoading={isLoading}
      />
    </>
  );
}
