import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { supabase } from '../../lib/supabase';
import { AppLayout } from '../../components/layout/AppLayout';
import { DataTable, Th, Td } from '../../components/ui/DataTable';

export function TreatmentsPage() {
  const { data, isLoading } = useQuery({ queryKey: ['treatments'], queryFn: async () => {
    const { data } = await supabase.from('treatments').select('*, disease:disease_id(name_en)').limit(10);
    return data ?? [];
  }});

  return (
    <AppLayout title="Treatments" subtitle="Manage">
      <DataTable loading={isLoading} empty={!isLoading && data?.length === 0}>
        <thead><tr><Th>Disease</Th><Th>Kind</Th><Th>Steps</Th></tr></thead>
        <tbody>
          {data?.map((t) => (
            <tr key={t.id}>
              <Td>{(t as any).disease?.name_en}</Td>
              <Td>{t.kind}</Td>
              <Td>{t.steps_en}</Td>
            </tr>
          ))}
        </tbody>
      </DataTable>
    </AppLayout>
  );
}
