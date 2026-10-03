import { Sidebar } from './Sidebar';
import { Topbar } from './Topbar';
import { useRealtimeQueue } from '../../hooks/useRealtimeQueue';

interface AppLayoutProps {
  title: string;
  subtitle?: string;
  children: React.ReactNode;
}

export function AppLayout({ title, subtitle, children }: AppLayoutProps) {
  // Mount the realtime queue toast observer
  useRealtimeQueue();

  return (
    <div className="flex min-h-screen bg-slate-50 font-sans" style={{ background: 'var(--color-bg)' }}>
      <Sidebar />
      <div className="flex-1 flex flex-col min-w-0">
        <Topbar title={title} subtitle={subtitle} />
        <main className="flex-1 p-8 overflow-y-auto">
          <div className="max-w-7xl mx-auto">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
