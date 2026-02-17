import SelectField from "@/shared/ui/SelectFiled";
import { useTranslation } from "react-i18next";

export default function UsersRoles({
  value,
  onChange,
}: {
  value: string;
  onChange: (value: string) => void;
}) {
  const { t } = useTranslation('users');

  const AllRoles = [
    { label: t('roles.all'), value: "all" },
    { label: t('roles.admin'), value: "ADMIN" },
    { label: t('roles.hospitalUser'), value: "HOSPITAL_USER" },
    { label: t('roles.ambulanceUser'), value: "AMBULANCE_USER" },
  ];

  return (
    <>
      <SelectField
        label=""
        placeholder={t('roles.all')}
        value={value}
        onChange={onChange}
        options={AllRoles}
      />
    </>
  );
}
