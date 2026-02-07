import type { User } from "../types/users.types";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { userSchema } from "../schemas/modal.schema";
import { useEffect } from "react";
import type { z } from "zod";

type UserFormData = z.infer<typeof userSchema>;

interface UserFormModalProps {
  onSubmit: (user: User) => void;
  user?: User;
  mode: "add" | "edit";
}

export default function useModal({
  onSubmit,
  user,
  mode,
}: UserFormModalProps) {
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<UserFormData>({
    resolver: zodResolver(userSchema),
    defaultValues: {
      id: "",
      name: "",
      email: "",
      password: "",
      roleId: "HOSPITAL_USER",
    },
  });

  useEffect(() => {
    if (user && mode === "edit") {
      reset(user);
    } else {
      reset({
        id: `USR-${Date.now()}`,
        name: "",
        email: "",
        password: "",
        roleId: "HOSPITAL_USER",
      });
    }
  }, [user, mode, reset]);

  const submitHandler = handleSubmit((data) => {
    onSubmit(data as User);
  });

  return {
    register,
    submitHandler,
    errors,
  };
}
