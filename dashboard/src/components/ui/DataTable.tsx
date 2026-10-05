import { ChevronLeft, ChevronRight } from 'lucide-react';

export function Th({ children }: { children: React.ReactNode }) {
  return (
    <th className="px-6 py-4 text-left text-[11px] font-bold tracking-wider uppercase bg-gray-50/50" style={{ color: 'var(--color-text-muted)', borderBottom: '1px solid var(--color-card-border)' }}>
      {children}
    </th>
  );
}

export function Td({ children }: { children: React.ReactNode }) {
  return (
    <td className="px-6 py-4 whitespace-nowrap" style={{ borderBottom: '1px solid var(--color-card-border)' }}>
      {children}
    </td>
  );
}

interface DataTableProps {
  loading?: boolean;
  empty?: boolean;
  emptyText?: string;
  children: React.ReactNode;
}

export function DataTable({ loading, empty, emptyText = 'No records found.', children }: DataTableProps) {
  return (
    <div className="lumina-card overflow-hidden">
      <div className="overflow-x-auto">
        <table className="w-full min-w-max">
          {children}
        </table>
      </div>
      {loading && (
        <div className="px-6 py-8 text-center text-[13px] font-medium" style={{ color: 'var(--color-text-muted)' }}>
          <div className="w-6 h-6 border-2 border-t-transparent rounded-full animate-spin mx-auto mb-2" style={{ borderColor: 'var(--color-primary-light)', borderTopColor: 'transparent' }} />
          Loading data...
        </div>
      )}
      {!loading && empty && (
        <div className="px-6 py-12 text-center text-[13px] font-medium" style={{ color: 'var(--color-text-muted)' }}>
          {emptyText}
        </div>
      )}
    </div>
  );
}

interface PaginationProps {
  page: number;
  pageSize: number;
  total: number;
  onPageChange: (page: number) => void;
}

export function Pagination({ page, pageSize, total, onPageChange }: PaginationProps) {
  const totalPages = Math.ceil(total / pageSize);
  if (totalPages <= 1) return null;

  return (
    <div className="flex items-center justify-between px-2 py-4">
      <p className="text-[12px]" style={{ color: 'var(--color-text-muted)' }}>
        Showing <span className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>{(page - 1) * pageSize + 1}</span> to <span className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>{Math.min(page * pageSize, total)}</span> of <span className="font-semibold" style={{ color: 'var(--color-text-primary)' }}>{total}</span> results
      </p>
      <div className="flex gap-2">
        <button
          disabled={page === 1}
          onClick={() => onPageChange(page - 1)}
          className="w-8 h-8 rounded-lg flex items-center justify-center transition-colors hover:bg-gray-100 disabled:opacity-50"
          style={{ border: '1px solid var(--color-card-border)', background: 'var(--color-bg)' }}
        >
          <ChevronLeft size={16} />
        </button>
        <button
          disabled={page === totalPages}
          onClick={() => onPageChange(page + 1)}
          className="w-8 h-8 rounded-lg flex items-center justify-center transition-colors hover:bg-gray-100 disabled:opacity-50"
          style={{ border: '1px solid var(--color-card-border)', background: 'var(--color-bg)' }}
        >
          <ChevronRight size={16} />
        </button>
      </div>
    </div>
  );
}
