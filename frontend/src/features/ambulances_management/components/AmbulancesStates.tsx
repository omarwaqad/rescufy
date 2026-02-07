import SelectField from "@/shared/ui/SelectFiled";

export default function AmbulancesStates({
  value,
  onChange,
}: {
  value: string;
  onChange: (value: string) => void;
}) {
  const AllStates = [
    { label: "All States", value: "all" },
    { label: "Available", value: "AVAILABLE" },
    { label: "In Transit", value: "IN_TRANSIT" },
    { label: "Busy", value: "BUSY" },
    { label: "Maintenance", value: "MAINTENANCE" },
  ];

  return (
    <>
      <SelectField
        label=""
        placeholder="All States"
        value={value}
        onChange={onChange}
        options={AllStates}
      />
    </>
  );
}
