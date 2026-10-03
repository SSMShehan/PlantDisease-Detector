import type { LucideIcon } from 'lucide-react';
import clsx from 'clsx';

interface StatCardProps {
  label: string;
  value: string | number;
  icon: LucideIcon;
  color: string;
  trend?: {
    value: number;
    isUp: boolean;
  };
  onClick?: () => void;
}

export function StatCard({ label, value, icon: Icon, color, trend, onClick }: StatCardProps) {
  return (
    <div 
      className={clsx(
        "lumina-card p-5 relative overflow-hidden transition-all",
        onClick && "cursor-pointer hover:shadow-xl hover:-translate-y-1"
      )}
      onClick={onClick}
    >
      <div 
        className="absolute top-0 right-0 w-24 h-24 rounded-bl-full opacity-10 pointer-events-none transition-transform group-hover:scale-110"
        style={{ background: color }}
      />
      
      <div className="flex items-start justify-between">
        <div className="w-12 h-12 rounded-2xl flex items-center justify-center shadow-sm" style={{ background: `${color}14`, border: `1px solid ${color}22` }}>
          <Icon size={22} color={color} />
        </div>
        
        {trend && (
          <span className={clsx(
            "text-[11px] font-bold px-2 py-1 rounded-lg flex items-center gap-1",
            trend.isUp ? "bg-emerald-50 text-emerald-600" : "bg-red-50 text-red-500"
          )}>
            {trend.isUp ? '↑' : '↓'} {trend.value}%
          </span>
        )}
      </div>

      <div className="mt-4">
        <h4 className="text-[28px] font-black tracking-tight" style={{ color: 'var(--color-text-primary)' }}>
          {value}
        </h4>
        <p className="text-[12px] font-semibold mt-1" style={{ color: 'var(--color-text-muted)' }}>
          {label}
        </p>
      </div>
    </div>
  );
}
