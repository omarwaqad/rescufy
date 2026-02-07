import type { Ambulance } from "../types/ambulances.types";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { ambulanceSchema } from "../schemas/modal.schema";
import { useEffect } from "react";
import type { z } from "zod";

type AmbulanceFormData = z.infer<typeof ambulanceSchema>;

interface AmbulanceFormModalProps {
  onSubmit: (ambulance: Ambulance) => void;
  ambulance?: Ambulance;
  mode: "add" | "edit";
}

export default function useModal({
  onSubmit,
  ambulance,
  mode,
}: AmbulanceFormModalProps) {
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<AmbulanceFormData>({
    resolver: zodResolver(ambulanceSchema),
    defaultValues: {
      id: "",
      licensePlate: "",
      hospitalId: "",
      status: "AVAILABLE",
      latitude: 0,
      longitude: 0,
    },
  });

  useEffect(() => {
    if (ambulance && mode === "edit") {
      reset(ambulance);
    } else {
      reset({
        id: `AMB-${Date.now()}`,
        licensePlate: "",
        hospitalId: "",
        status: "AVAILABLE",
        latitude: 0,
        longitude: 0,
      });
    }
  }, [ambulance, mode, reset]);

  const submitHandler = handleSubmit((data) => {
    onSubmit(data as Ambulance);
  });

  return {
    register,
    submitHandler,
    errors,
  };
}
