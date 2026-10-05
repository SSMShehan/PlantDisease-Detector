import clsx from 'clsx';

interface BadgeProps {
  status: string;
  dot?: boolean;
}

export function Badge({ status, dot }: BadgeProps) {
  let bg = '';
  let text = '';
  let border = '';
  let dotColor = '';
  let label = status.replace('_', ' ');

  switch (status.toLowerCase()) {
    case 'active':
    case 'resolved':
    case 'open_report':
      bg = 'bg-emerald-500/12';
      text = 'text-emerald-600';
      border = 'border-emerald-400/30';
      dotColor = 'bg-emerald-500';
      break;
    case 'pending':
    case 'in_progress':
    case 'open':
      bg = 'bg-amber-500/12';
      text = 'text-amber-600';
      border = 'border-amber-400/30';
      dotColor = 'bg-amber-500';
      break;
    case 'banned':
    case 'closed':
    case 'wontfix':
      bg = 'bg-red-500/12';
      text = 'text-red-500';
      border = 'border-red-400/30';
      dotColor = 'bg-red-500';
      break;
    default:
      bg = 'bg-slate-400/12';
      text = 'text-slate-500';
      border = 'border-slate-300/40';
      dotColor = 'bg-slate-500';
      break;
  }

  return (
    <span className={clsx('badge', bg, text, border)}>
      {dot && <span className={clsx('w-1.5 h-1.5 rounded-full mr-1.5', dotColor)} />}
      <span className="capitalize">{label}</span>
    </span>
  );
}

export function RoleBadge({ role }: { role: string }) {
  let bg = '';
  let text = '';
  let border = '';

  switch (role) {
    case 'admin':
      bg = 'bg-violet-500/12';
      text = 'text-violet-600';
      border = 'border-violet-400/30';
      break;
    case 'officer':
      bg = 'bg-blue-500/12';
      text = 'text-blue-500';
      border = 'border-blue-400/30';
      break;
    default:
      bg = 'bg-emerald-500/12';
      text = 'text-emerald-600';
      border = 'border-emerald-400/30';
      break;
  }

  return <span className={clsx('badge capitalize', bg, text, border)}>{role}</span>;
}
