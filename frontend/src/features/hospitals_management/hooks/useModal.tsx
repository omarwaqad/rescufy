import type { Hospital } from "../types/hospitals.types";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { hospitalSchema } from "../schemas/modal.schema";
import { useEffect } from "react";
import type { z } from "zod";

type HospitalFormData = z.infer<typeof hospitalSchema>;

interface HospitalFormModalProps {
  onSubmit: (hospital: Hospital) => void;
  hospital?: Hospital;
  mode: "add" | "edit";
}

export default function useModal({
  onSubmit,
  hospital,
  mode,
}: HospitalFormModalProps) {
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<HospitalFormData>({
    resolver: zodResolver(hospitalSchema),
    defaultValues: {
      id: "",
      name: "",
      email: "",
      phone: "",
      address: "",
      status: "NORMAL",
      totalBeds: 0,
      usedBeds: 0,
    },
  });

  useEffect(() => {
    if (hospital && mode === "edit") {
      reset(hospital);
    } else {
      reset({
        id: `Hospital-${Date.now()}`,
        name: "",
        email: "",
        phone: "",
        address: "",
        status: "NORMAL",
        totalBeds: 0,
        usedBeds: 0,
      });
    }
  }, [hospital, mode, reset]);

  const submitHandler = handleSubmit((data) => {
    onSubmit(data as Hospital);
    
  });

  return {
    register,
    submitHandler,
    errors,
  };
}
