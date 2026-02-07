import z from "zod";

export const hospitalSchema = z
  .object({
    id: z.string(),
    name: z.string().min(1, "Hospital name is required"),
    email: z.email("Invalid email format").min(1, "Email is required"),
    phone: z
      .string()
      .min(1, "Phone number is required")
      .regex(/^[\d\s\-+()]+$/, "Invalid phone number format"),
    address: z.string().min(1, "Address is required"),
    status: z.enum(["NORMAL", "BUSY", "CRITICAL", "FULL"]),
    totalBeds: z.number().int().positive("Total beds must be greater than 0"),
    usedBeds: z.number().int().min(0, "Used beds cannot be negative"),
  })
  .refine((data) => data.usedBeds <= data.totalBeds, {
    message: "Used beds cannot exceed total beds",
    path: ["usedBeds"],
  });
