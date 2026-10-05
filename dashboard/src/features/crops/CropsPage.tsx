import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '../../lib/supabase';
import { AppLayout } from '../../components/layout/AppLayout';
import { DataTable, Th, Td } from '../../components/ui/DataTable';
import { Modal, ConfirmModal } from '../../components/ui/Modal';
import { Badge } from '../../components/ui/Badge';
import { Plus, Edit2, Trash2 } from 'lucide-react';
import toast from 'react-hot-toast';

export function CropsPage() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editTarget, setEditTarget] = useState<any>(null);
  const [deleteTarget, setDeleteTarget] = useState<any>(null);
  const [form, setForm] = useState({ name: '', name_si: '', name_ta: '', season: '', is_active: true });

  const { data, isLoading } = useQuery({ queryKey: ['crops'], queryFn: async () => {
    const { data } = await supabase.from('crop_categories').select('*').order('name', { ascending: true });
    return data ?? [];
  }});

  const upsertMutation = useMutation({
    mutationFn: async (payload: any) => {
      if (editTarget) {
        const { error } = await supabase.from('crop_categories').update(payload).eq('id', editTarget.id);
        if (error) throw error;
      } else {
        const { error } = await supabase.from('crop_categories').insert(payload);
        if (error) throw error;
      }
    },
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['crops'] }); setModalOpen(false); setEditTarget(null); toast.success('Saved!'); }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: string) => { const { error } = await supabase.from('crop_categories').delete().eq('id', id); if (error) throw error; },
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['crops'] }); setDeleteTarget(null); toast.success('Deleted'); }
  });

  return (
    <AppLayout title="Crops" subtitle="Manage plant categories">
      <div className="mb-4"><button className="btn-primary" onClick={() => { setEditTarget(null); setForm({ name: '', name_si: '', name_ta: '', season: '', is_active: true }); setModalOpen(true); }}><Plus size={14}/> Add Crop</button></div>
      <DataTable loading={isLoading} empty={!isLoading && data?.length === 0}>
        <thead><tr><Th>Name (EN)</Th><Th>Name (SI)</Th><Th>Season</Th><Th>Status</Th><Th>Actions</Th></tr></thead>
        <tbody>
          {data?.map((c) => (
            <tr key={c.id}>
              <Td><span className="font-medium text-gray-900">{c.name}</span></Td>
              <Td>{c.name_si || '-'}</Td>
              <Td>{c.season}</Td>
              <Td><Badge status={c.is_active ? 'active' : 'inactive'} /></Td>
              <Td>
                <div className="flex items-center gap-2">
                  <button onClick={() => { setEditTarget(c); setForm(c); setModalOpen(true); }} className="p-2 hover:bg-gray-100 rounded"><Edit2 size={14}/></button>
                  <button onClick={() => setDeleteTarget(c)} className="p-2 hover:bg-red-50 rounded"><Trash2 size={14} color="#D94E4E"/></button>
                </div>
              </Td>
            </tr>
          ))}
        </tbody>
      </DataTable>

      <Modal open={modalOpen} onClose={() => { setModalOpen(false); setEditTarget(null); }} title={editTarget ? 'Edit Crop' : 'New Crop'}>
        <div className="space-y-4">
          <div><label className="lumina-label">Crop Name (EN)</label><input className="lumina-input" value={form.name} onChange={e => setForm({...form, name: e.target.value})} /></div>
          <div className="grid grid-cols-2 gap-4">
            <div><label className="lumina-label">Name (SI)</label><input className="lumina-input" value={form.name_si || ''} onChange={e => setForm({...form, name_si: e.target.value})} /></div>
            <div><label className="lumina-label">Name (TA)</label><input className="lumina-input" value={form.name_ta || ''} onChange={e => setForm({...form, name_ta: e.target.value})} /></div>
          </div>
          <div><label className="lumina-label">Season</label><input className="lumina-input" value={form.season || ''} onChange={e => setForm({...form, season: e.target.value})} placeholder="Yala & Maha" /></div>
          <div className="flex items-center gap-2 pt-2">
            <input type="checkbox" id="active" checked={form.is_active} onChange={e => setForm({...form, is_active: e.target.checked})} />
            <label htmlFor="active" className="text-[13px] font-medium">Active (Visible in App)</label>
          </div>
          <div className="flex justify-end gap-3 pt-4 border-t">
            <button className="btn-secondary" onClick={() => setModalOpen(false)}>Cancel</button>
            <button className="btn-primary" onClick={() => upsertMutation.mutate(form)}>Save</button>
          </div>
        </div>
      </Modal>

      <ConfirmModal open={!!deleteTarget} onClose={() => setDeleteTarget(null)} onConfirm={() => deleteTarget && deleteMutation.mutate(deleteTarget.id)} title="Delete Crop?" message="Are you sure?" />
    </AppLayout>
  );
}
