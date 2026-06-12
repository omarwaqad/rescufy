import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Outlet, useLocation } from "react-router-dom";

import SideBar from "../../components/SideBar";
import AdminNavbar from "../../components/AdminNavBar";
import Breadcrumb from "../../components/Breadcrumb";
import Footer from "@/components/Footer";

import { useMediaQuery } from "../../shared/hooks/useMediaQuery";

export default function AdminLayout() {
  const isDesktop = useMediaQuery("(min-width: 768px)");
  const [sidebarOpen, setSidebarOpen] = useState(isDesktop);
  const [isExpanded, setIsExpanded] = useState(false);

  const location = useLocation();

  useEffect(() => {
    setSidebarOpen(isDesktop);
  }, [isDesktop]);

  const toggleSidebar = () => setSidebarOpen((prev) => !prev);

  const closeSidebar = () => {
    if (!isDesktop) {
      setSidebarOpen(false);
    }
  };

  return (
    <div className="flex min-h-screen bg-background">
      {/* Mobile Overlay */}
      <AnimatePresence>
        {sidebarOpen && !isDesktop && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.01 }}
            className="fixed inset-0 z-40 bg-black/10 backdrop-blur-xs"
            onClick={closeSidebar}
          />
        )}
      </AnimatePresence>

      {/* Sidebar */}
      <SideBar
        isOpen={sidebarOpen}
        onClose={closeSidebar}
        isExpanded={isExpanded}
        setIsExpanded={setIsExpanded}
      />

      {/* Right Section */}
      <div className="flex flex-1 flex-col min-h-screen min-w-0 ">
        {/* Navbar */}
        <AdminNavbar
          onMenuClick={toggleSidebar}
          isExpanded={isExpanded}
          setIsExpanded={setIsExpanded}
        />

        {/* Main Content */}
        <main className="flex-1 pt-20 md:pt-24 pb-6 md:px-10 px-4 lg:px-5 w-full max-w-7xl mx-auto">
          <Breadcrumb />

          <AnimatePresence mode="wait">
            <motion.div
              key={location.pathname}
              initial={{ opacity: 0, y: 2 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.3 }}
            >
              <Outlet />
            </motion.div>
          </AnimatePresence>
        </main>

        {/* Footer */}
        <div className="mt-auto lg:pl-10">
          <Footer />
        </div>
      </div>
    </div>
  );
}
