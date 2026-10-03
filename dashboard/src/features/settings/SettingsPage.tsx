import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { supabase } from '../../lib/supabase';
import { AppLayout } from '../../components/layout/AppLayout';
import toast from 'react-hot-toast';

export function SettingsPage() {
  const queryClient = useQueryClient();
  const [editing, setEditing] = useState<string | null>(null);
  const [editValue, setEditValue] = useState('');

  const { data, isLoading } = useQuery({ queryKey: ['settings'], queryFn: async () => {
    const { data } = await supabase.from('system_settings').select('*').order('key', { ascending: true });
    return data ?? [];
  }});

  const updateMutation = useMutation({
    mutationFn: async ({ key, value }: { key: string, value: string }) => {
      const { error } = await supabase.from('system_settings').update({ value }).eq('key', key);
      if (error) throw error;
    },
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['settings'] }); setEditing(null); toast.success('Saved'); }
  });

  return (
    <AppLayout title="System Settings" subtitle="Configure core platform parameters">
      {isLoading ? <div className="p-8 text-center text-gray-500">Loading settings...</div> : (
        <div className="space-y-4 max-w-4xl">
          {data?.map((s) => (
            <div key={s.key} className="lumina-card p-6 flex flex-col md:flex-row md:items-center justify-between gap-4">
              <div className="flex-1">
                <p className="font-bold text-[14px] text-gray-900">{s.label || s.key}</p>
                <p className="text-[13px] text-gray-500 mt-1">{s.description}</p>
                <code className="text-[10px] text-gray-400 mt-2 block">{s.key}</code>
              </div>
              
              <div className="flex items-center gap-3 w-full md:w-auto">
                {editing === s.key ? (
                  <>
                    <input className="lumina-input py-1.5 w-full md:w-48" value={editValue} onChange={e => setEditValue(e.target.value)} autoFocus />
                    <button className="btn-primary py-1.5 px-4 text-xs" onClick={() => updateMutation.mutate({ key: s.key, value: editValue })}>Save</button>
                    <button className="btn-secondary py-1.5 px-4 text-xs" onClick={() => setEditing(null)}>Cancel</button>
                  </>
                ) : (
                  <>
                    <div className="px-4 py-2 bg-gray-50 border rounded-lg font-mono text-[13px] text-gray-700 min-w-[120px] text-center">{s.value}</div>
                    <button className="btn-secondary py-1.5 px-4 text-xs" onClick={() => { setEditing(s.key); setEditValue(s.value); }}>Edit</button>
                  </>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </AppLayout>
  );
}
