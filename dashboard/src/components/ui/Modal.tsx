import { useEffect } from 'react';
import { X, AlertTriangle } from 'lucide-react';
import clsx from 'clsx';

interface ModalProps {
  open: boolean;
  onClose: () => void;
  title: string;
  subtitle?: string;
  children: React.ReactNode;
  maxWidth?: number;
}

export function Modal({ open, onClose, title, subtitle, children, maxWidth = 500 }: ModalProps) {
  useEffect(() => {
    if (open) document.body.style.overflow = 'hidden';
    else document.body.style.overflow = 'auto';
    return () => { document.body.style.overflow = 'auto'; };
  }, [open]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6" style={{ background: 'rgba(11, 60, 45, 0.4)', backdropFilter: 'blur(4px)' }}>
      <div className="absolute inset-0" onClick={onClose} />
      
      <div 
        className={clsx('relative w-full rounded-2xl shadow-2xl animate-enter flex flex-col max-h-full overflow-hidden')}
        style={{ maxWidth, background: '#fff', border: '1px solid var(--color-card-border)' }}
      >
        <div className="flex items-start justify-between px-6 py-5 shrink-0" style={{ borderBottom: '1px solid var(--color-card-border)', background: 'var(--color-bg)' }}>
          <div>
            <h2 className="text-[18px] font-bold" style={{ color: 'var(--color-text-primary)' }}>{title}</h2>
            {subtitle && <p className="text-[12px] mt-0.5" style={{ color: 'var(--color-text-muted)' }}>{subtitle}</p>}
          </div>
          <button onClick={onClose} className="p-1.5 rounded-lg hover:bg-gray-100 transition-colors">
            <X size={18} style={{ color: 'var(--color-text-muted)' }} />
          </button>
        </div>
        
        <div className="p-6 overflow-y-auto">
          {children}
        </div>
      </div>
    </div>
  );
}

interface ConfirmModalProps {
  open: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  message: string;
  loading?: boolean;
}

export function ConfirmModal({ open, onClose, onConfirm, title, message, loading }: ConfirmModalProps) {
  return (
    <Modal open={open} onClose={onClose} title={title} maxWidth={400}>
      <div className="flex items-start gap-4 mb-6">
        <div className="w-10 h-10 rounded-full flex items-center justify-center shrink-0" style={{ background: 'rgba(217, 78, 78, 0.12)' }}>
          <AlertTriangle size={20} color="#D94E4E" />
        </div>
        <p className="text-[13px] pt-1" style={{ color: 'var(--color-text-secondary)' }}>{message}</p>
      </div>
      
      <div className="flex justify-end gap-3 pt-4" style={{ borderTop: '1px solid var(--color-card-border)' }}>
        <button className="btn-secondary" onClick={onClose} disabled={loading}>Cancel</button>
        <button className="btn-danger" onClick={onConfirm} disabled={loading}>
          {loading ? 'Confirming...' : 'Confirm'}
        </button>
      </div>
    </Modal>
  );
}
