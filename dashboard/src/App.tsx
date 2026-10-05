import { Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from './hooks/useAuth';

import { LoginPage } from './features/auth/LoginPage';
import { DashboardPage } from './features/dashboard/DashboardPage';
import { FarmersPage } from './features/farmers/FarmersPage';
import { OfficersPage } from './features/officers/OfficersPage';
import { DiseasesPage } from './features/diseases/DiseasesPage';
import { TreatmentsPage } from './features/treatments/TreatmentsPage';
import { CropsPage } from './features/crops/CropsPage';
import { CasesPage } from './features/cases/CasesPage';
import { AnnouncementsPage } from './features/announcements/AnnouncementsPage';
import { FeedbackPage } from './features/feedback/FeedbackPage';
import { RegionsPage } from './features/regions/RegionsPage';
import { SettingsPage } from './features/settings/SettingsPage';

// ── Protected Route Wrapper ───────────────────────────────────────────────────
function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="h-screen w-screen flex items-center justify-center" style={{ background: 'var(--color-bg)' }}>
        <div className="w-10 h-10 rounded-full border-4 border-t-transparent animate-spin" style={{ borderColor: 'var(--color-primary-light)', borderTopColor: 'transparent' }} />
      </div>
    );
  }

  if (!user || user.role !== 'admin') {
    return <Navigate to="/login" replace />;
  }

  return <>{children}</>;
}

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      
      {/* ── Protected Admin Routes ────────────────────────────────────────── */}
      <Route path="/" element={<ProtectedRoute><DashboardPage /></ProtectedRoute>} />
      
      <Route path="/farmers" element={<ProtectedRoute><FarmersPage /></ProtectedRoute>} />
      <Route path="/officers" element={<ProtectedRoute><OfficersPage /></ProtectedRoute>} />
      
      <Route path="/diseases" element={<ProtectedRoute><DiseasesPage /></ProtectedRoute>} />
      <Route path="/treatments" element={<ProtectedRoute><TreatmentsPage /></ProtectedRoute>} />
      <Route path="/crops" element={<ProtectedRoute><CropsPage /></ProtectedRoute>} />
      
      <Route path="/cases" element={<ProtectedRoute><CasesPage /></ProtectedRoute>} />
      <Route path="/announcements" element={<ProtectedRoute><AnnouncementsPage /></ProtectedRoute>} />
      <Route path="/feedback" element={<ProtectedRoute><FeedbackPage /></ProtectedRoute>} />
      
      <Route path="/regions" element={<ProtectedRoute><RegionsPage /></ProtectedRoute>} />
      <Route path="/settings" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />

      {/* Catch-all */}
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}
