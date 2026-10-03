import { useEffect, useRef } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { supabase } from '../lib/supabase';
import toast from 'react-hot-toast';

export function useRealtimeQueue() {
  const queryClient = useQueryClient();
  const channelRef = useRef<ReturnType<typeof supabase.channel> | null>(null);

  useEffect(() => {
    const channel = supabase
      .channel('lumina-admin-realtime')
      .on(
        'postgres_changes',
        { event: '*', schema: 'public' },
        (payload) => {
          // Re-fetch everything
          queryClient.invalidateQueries();

          // If a new case or feedback arrives, show a toast notification
          if (payload.eventType === 'INSERT' && (payload.table === 'consultations' || payload.table === 'feedback')) {
            const title = payload.table === 'consultations' ? 'New Consultation Case' : 'New Feedback';
            const desc = payload.table === 'consultations' ? 'A new farmer case needs attention' : 'A user submitted feedback';
            
            toast.custom((t) => (
              <div className={`${t.visible ? 'animate-enter' : 'animate-leave'} max-w-sm bg-white shadow-lg rounded-2xl border border-amber-200 p-4 flex items-start gap-3`}>
                <div className="w-2 h-2 rounded-full bg-red-500 mt-1 animate-pulse-dot flex-shrink-0" />
                <div>
                  <p className="font-semibold text-sm text-gray-800">{title}</p>
                  <p className="text-xs text-gray-500 mt-0.5">{desc}</p>
                </div>
              </div>
            ), { duration: 5000 });
          }
        }
      )
      .subscribe();

    channelRef.current = channel;
    return () => { supabase.removeChannel(channel); };
  }, [queryClient]);
}
