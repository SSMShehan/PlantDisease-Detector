import { formatDistanceToNow, format } from 'date-fns';

export function getInitials(name: string | null | undefined): string {
  if (!name) return '?';
  return name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
}

export function formatDate(dateString: string | null | undefined): string {
  if (!dateString) return '—';
  return format(new Date(dateString), 'MMM d, yyyy');
}

export function formatDateTime(dateString: string | null | undefined): string {
  if (!dateString) return '—';
  return format(new Date(dateString), 'MMM d, yyyy h:mm a');
}

export function timeAgo(dateString: string | null | undefined): string {
  if (!dateString) return '—';
  return formatDistanceToNow(new Date(dateString), { addSuffix: true });
}

export function truncate(text: string, length: number): string {
  if (!text) return '';
  if (text.length <= length) return text;
  return text.substring(0, length) + '...';
}
