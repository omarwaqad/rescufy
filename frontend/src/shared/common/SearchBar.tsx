import type { ReactNode } from "react";
import SearchInput from "../ui/SearchInput";

type searchProps = {
  children: ReactNode;
  value: string;
  onSearchChange: (value: string) => void;
  placeholder?: string;
};

export default function SearchBar({
  placeholder,
  children,
  value,
  onSearchChange,
}: searchProps) {
  return (
    <>
      <div className="bg-bg-card py-4 px-4 md:px-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4 md:gap-4 rounded-lg shadow-card">
        <div className="w-full md:w-1/2">
          <SearchInput value={value} onSearchChange={onSearchChange} placeholder={placeholder} />
        </div>
 
    {/* filter props */}
        <div className="w-full md:w-1/4">
          {children}
        </div>
      </div>
    </>
  );
}
