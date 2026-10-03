import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '../../lib/supabase';
import { AppLayout } from '../../components/layout/AppLayout';
import { DataTable, Th, Td } from '../../components/ui/DataTable';
import { Modal, ConfirmModal } from '../../components/ui/Modal';
import { Plus, Edit2, Trash2 } from 'lucide-react';
import toast from 'react-hot-toast';

export function RegionsPage() {
  const queryClient = useQueryClient();
  const [modalOpen, setModalOpen] = useState(false);
  const [editTarget, setEditTarget] = useState<any>(null);
  const [deleteTarget, setDeleteTarget] = useState<any>(null);
  const [form, setForm] = useState({ name: '', province: '', district: '' });

  const { data, isLoading } = useQuery({ queryKey: ['regions'], queryFn: async () => {
    const { data } = await supabase.from('regions').select('*').limit(20);
    return data ?? [];
  }});

  const upsertMutation = useMutation({
    mutationFn: async (payload: any) => {
      if (editTarget) {
        const { error } = await supabase.from('regions').update(payload).eq('id', editTarget.id);
        if (error) throw error;
      } else {
        const { error } = await supabase.from('regions').insert(payload);
        if (error) throw error;
      }
    },
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['regions'] }); setModalOpen(false); setEditTarget(null); toast.success('Saved!'); }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: string) => { const { error } = await supabase.from('regions').delete().eq('id', id); if (error) throw error; },
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['regions'] }); setDeleteTarget(null); toast.success('Deleted'); }
  });

  return (
    <AppLayout title="Regions" subtitle="Manage agricultural zones">
      <div className="mb-4"><button className="btn-primary" onClick={() => { setEditTarget(null); setForm({ name: '', province: '', district: '' }); setModalOpen(true); }}><Plus size={14}/> Add Region</button></div>
      <DataTable loading={isLoading} empty={!isLoading && data?.length === 0}>
        <thead><tr><Th>Name</Th><Th>Province</Th><Th>District</Th><Th>Actions</Th></tr></thead>
        <tbody>
          {data?.map((r) => (
            <tr key={r.id}>
              <Td>{r.name}</Td>
              <Td>{r.province}</Td>
              <Td>{r.district}</Td>
              <Td>
                <div className="flex items-center gap-2">
                  <button onClick={() => { setEditTarget(r); setForm(r); setModalOpen(true); }} className="p-2 hover:bg-gray-100 rounded"><Edit2 size={14}/></button>
                  <button onClick={() => setDeleteTarget(r)} className="p-2 hover:bg-red-50 rounded"><Trash2 size={14} color="#D94E4E"/></button>
                </div>
              </Td>
            </tr>
          ))}
        </tbody>
      </DataTable>

      <Modal open={modalOpen} onClose={() => { setModalOpen(false); setEditTarget(null); }} title={editTarget ? 'Edit Region' : 'New Region'}>
        <div className="space-y-4">
          <div><label className="lumina-label">Region Name</label><input className="lumina-input" value={form.name} onChange={e => setForm({...form, name: e.target.value})} /></div>
          <div><label className="lumina-label">Province</label><input className="lumina-input" value={form.province} onChange={e => setForm({...form, province: e.target.value})} /></div>
          <div><label className="lumina-label">District</label><input className="lumina-input" value={form.district} onChange={e => setForm({...form, district: e.target.value})} /></div>
          <div className="flex justify-end gap-3 pt-4 border-t">
            <button className="btn-secondary" onClick={() => setModalOpen(false)}>Cancel</button>
            <button className="btn-primary" onClick={() => upsertMutation.mutate(form)}>Save</button>
          </div>
        </div>
      </Modal>

      <ConfirmModal open={!!deleteTarget} onClose={() => setDeleteTarget(null)} onConfirm={() => deleteTarget && deleteMutation.mutate(deleteTarget.id)} title="Delete Region?" message="Are you sure?" />
    </AppLayout>
  );
}
