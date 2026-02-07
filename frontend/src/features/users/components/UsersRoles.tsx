import SelectField from "@/shared/ui/SelectFiled";

export default function UsersRoles({
  value,
  onChange,
}: {
  value: string;
  onChange: (value: string) => void;
}) {
  const AllRoles = [
    { label: "All Roles", value: "all" },
    { label: "Admin", value: "ADMIN" },
    { label: "Hospital User", value: "HOSPITAL_USER" },
    { label: "Ambulance User", value: "AMBULANCE_USER" },
  ];

  return (
    <>
      <SelectField
        label=""
        placeholder="All Roles"
        value={value}
        onChange={onChange}
        options={AllRoles}
      />
    </>
  );
}
