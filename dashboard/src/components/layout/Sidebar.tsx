import { Link, useLocation } from 'react-router-dom';
import clsx from 'clsx';
import { 
  LayoutDashboard, 
  Users, 
  Briefcase, 
  Bug, 
  ThermometerSun, 
  Sprout, 
  ShieldAlert, 
  Megaphone, 
  MessageSquare, 
  Map, 
  Settings 
} from 'lucide-react';
import { useAuth } from '../../hooks/useAuth';

const NAV_GROUPS = [
  {
    label: 'Overview',
    items: [
      { label: 'Dashboard', path: '/', icon: LayoutDashboard },
    ]
  },
  {
    label: 'User Management',
    items: [
      { label: 'Farmers', path: '/farmers', icon: Users },
      { label: 'Ag-Officers', path: '/officers', icon: Briefcase },
    ]
  },
  {
    label: 'Knowledge Base',
    items: [
      { label: 'Diseases Directory', path: '/diseases', icon: Bug },
      { label: 'Treatments / Cures', path: '/treatments', icon: ThermometerSun },
      { label: 'Crop Categories', path: '/crops', icon: Sprout },
    ]
  },
  {
    label: 'Moderation & Ops',
    items: [
      { label: 'Case Overseer', path: '/cases', icon: ShieldAlert },
      { label: 'Announcements', path: '/announcements', icon: Megaphone },
      { label: 'Feedback & Bugs', path: '/feedback', icon: MessageSquare },
    ]
  },
  {
    label: 'System Admin',
    items: [
      { label: 'Regions', path: '/regions', icon: Map },
      { label: 'Global Settings', path: '/settings', icon: Settings },
    ]
  },
];

export function Sidebar() {
  const location = useLocation();
  const { signOut } = useAuth();

  return (
    <div className="w-[260px] h-screen flex flex-col border-r shadow-xl z-10 sticky top-0" style={{ background: '#0B3C2D', borderColor: 'rgba(255,255,255,0.1)' }}>
      {/* Brand */}
      <div className="h-[72px] flex items-center px-6 border-b" style={{ borderColor: 'rgba(255,255,255,0.1)' }}>
        <div className="w-8 h-8 rounded-lg flex items-center justify-center mr-3 overflow-hidden bg-white">
          <img src="/logo.png" alt="Lumina Logo" className="w-full h-full object-cover" />
        </div>
        <div>
          <h1 className="text-white font-black tracking-tight text-[18px]">Lumina AI</h1>
          <p className="text-[10px] font-medium tracking-widest uppercase opacity-70 text-white">Admin Console</p>
        </div>
      </div>

      {/* Nav */}
      <div className="flex-1 overflow-y-auto py-6 px-4 space-y-8 scrollbar-hide">
        {NAV_GROUPS.map((group) => (
          <div key={group.label}>
            <h3 className="text-[10px] font-bold uppercase tracking-wider mb-3 px-2 text-white/50">
              {group.label}
            </h3>
            <div className="space-y-1">
              {group.items.map((item) => {
                const isActive = location.pathname === item.path;
                return (
                  <Link
                    key={item.path}
                    to={item.path}
                    className={clsx(
                      "flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all duration-200",
                      isActive 
                        ? "bg-white/10 text-white shadow-sm font-semibold" 
                        : "text-white/70 hover:bg-white/5 hover:text-white"
                    )}
                  >
                    <item.icon size={18} className={isActive ? 'opacity-100 text-[#C87D55]' : 'opacity-70'} />
                    <span className="text-[13px]">{item.label}</span>
                  </Link>
                );
              })}
            </div>
          </div>
        ))}
      </div>

      {/* Footer */}
      <div className="p-4 border-t" style={{ borderColor: 'rgba(255,255,255,0.1)' }}>
        <button 
          onClick={() => signOut()}
          className="w-full py-2.5 rounded-xl flex items-center justify-center gap-2 text-[12px] font-bold transition-colors hover:bg-red-500/20 text-red-400"
        >
          Sign Out
        </button>
      </div>
    </div>
  );
}
