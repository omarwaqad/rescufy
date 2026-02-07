export interface User {
  id: string;
  name: string;
  email: string;
  password: string;
  roleId: string;
}

export const usersData: User[] = [
  {
    id: "USR-001",
    name: "Ahmed Hassan",
    email: "ahmed.hassan@rescufy.com",
    password: "Secure@123",
    roleId: "ADMIN",
  },
  {
    id: "USR-002",
    name: "Fatima Khalil",
    email: "fatima.khalil@rescufy.com",
    password: "Secure@456",
    roleId: "HOSPITAL_USER",
  },
  {
    id: "USR-003",
    name: "Mohamed Ali",
    email: "mohamed.ali@rescufy.com",
    password: "Secure@789",
    roleId: "AMBULANCE_USER",
  },
  {
    id: "USR-004",
    name: "Noor Saleh",
    email: "noor.saleh@rescufy.com",
    password: "Secure@101",
    roleId: "HOSPITAL_USER",
  },
  {
    id: "USR-005",
    name: "Karim Ibrahim",
    email: "karim.ibrahim@rescufy.com",
    password: "Secure@202",
    roleId: "AMBULANCE_USER",
  },
  {
    id: "USR-006",
    name: "Sara Mansour",
    email: "sara.mansour@rescufy.com",
    password: "Secure@303",
    roleId: "ADMIN",
  },
];

// Simulated API response
export const getUsersResponse = () => ({
  success: true,
  message: "Users retrieved successfully",
  data: usersData,
  timestamp: new Date().toISOString(),
});
