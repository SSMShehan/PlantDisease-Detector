import { useState } from 'react';
import { Navigate } from 'react-router-dom';
import { Sprout } from 'lucide-react';
import { useAuth } from '../../hooks/useAuth';
import toast from 'react-hot-toast';

export function LoginPage() {
  const { user, signIn, loading } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [submitting, setSubmitting] = useState(false);

  if (loading) {
    return (
      <div className="h-screen flex items-center justify-center bg-gray-50">
        <div className="w-8 h-8 border-4 border-emerald-600 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  // If already logged in and an admin, go to dashboard
  if (user && user.role === 'admin') {
    return <Navigate to="/" replace />;
  }

  async function handleLogin(e: React.FormEvent) {
    e.preventDefault();
    if (!email || !password) return;
    setSubmitting(true);
    try {
      await signIn(email, password);
    } catch (e: any) {
      toast.error(e.message || 'Login failed');
      setSubmitting(false);
    }
  }

  return (
    <div className="min-h-screen flex" style={{ background: 'var(--color-bg)' }}>
      {/* Left side - Login Form */}
      <div className="w-full md:w-1/2 flex items-center justify-center p-8">
        <div className="w-full max-w-md">
          <div className="w-16 h-16 rounded-2xl flex items-center justify-center mb-8 shadow-xl overflow-hidden bg-white">
            <img src="/logo.png" alt="Lumina Logo" className="w-full h-full object-cover" />
          </div>
          
          <h1 className="text-3xl font-black mb-2" style={{ color: 'var(--color-text-primary)' }}>Lumina Admin</h1>
          <p className="text-[14px] mb-8" style={{ color: 'var(--color-text-secondary)' }}>Sign in to the Plant Disease Manager platform.</p>

          <form onSubmit={handleLogin} className="space-y-5">
            <div>
              <label className="lumina-label">Email Address</label>
              <input 
                type="email" 
                className="lumina-input py-3"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="admin@lumina.local"
                required
              />
            </div>
            
            <div>
              <label className="lumina-label">Password</label>
              <input 
                type="password" 
                className="lumina-input py-3"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                required
              />
            </div>

            {user && user.role !== 'admin' && (
              <div className="p-3 bg-red-50 text-red-600 text-sm rounded-xl border border-red-200">
                This account is not an administrator. Please log in with an admin account.
              </div>
            )}

            <button 
              type="submit" 
              className="btn-primary w-full py-3 mt-4 text-[15px]"
              disabled={submitting || !email || !password}
            >
              {submitting ? 'Authenticating...' : 'Sign In'}
            </button>
          </form>
        </div>
      </div>

      {/* Right side - Premium Hero Area */}
      <div className="hidden md:flex w-1/2 relative overflow-hidden bg-[#0A261C]">
        {/* Dynamic Background Image */}
        <div 
          className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1628183060714-386d4fa156bc?q=80&w=2000&auto=format&fit=crop')] bg-cover bg-center"
        />
        
        {/* Premium Gradients for depth */}
        <div className="absolute inset-0 bg-gradient-to-br from-[#0B3C2D]/90 via-[#0B3C2D]/60 to-transparent" />
        <div className="absolute inset-0 bg-gradient-to-t from-[#0A261C] via-[#0A261C]/80 to-transparent opacity-90" />
        
        {/* Ambient Glows */}
        <div className="absolute top-0 right-0 w-[500px] h-[500px] bg-emerald-500/20 rounded-full blur-[120px] -translate-y-1/2 translate-x-1/3" />
        <div className="absolute bottom-0 left-0 w-[600px] h-[600px] bg-amber-500/10 rounded-full blur-[100px] translate-y-1/3 -translate-x-1/4" />

        {/* Content Container */}
        <div className="relative z-10 w-full h-full p-16 flex flex-col">
          
          {/* Top section with floating metrics */}
          <div className="flex-1 w-full relative">
            {/* Floating Card 1 */}
            <div className="absolute top-12 right-8 bg-white/10 backdrop-blur-xl border border-white/20 p-5 rounded-2xl shadow-2xl animate-float">
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 rounded-full bg-emerald-500/20 flex items-center justify-center text-emerald-300">
                  <Sprout size={24} />
                </div>
                <div>
                  <p className="text-white/70 text-xs font-medium uppercase tracking-wider mb-1">AI Accuracy</p>
                  <p className="text-white text-2xl font-black">98.4%</p>
                </div>
              </div>
            </div>

            {/* Floating Card 2 */}
            <div className="absolute top-48 left-8 bg-white/10 backdrop-blur-xl border border-white/20 p-5 rounded-2xl shadow-2xl animate-float" style={{ animationDelay: '1.5s' }}>
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 rounded-full bg-amber-500/20 flex items-center justify-center text-amber-300">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M12 2v20"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                </div>
                <div>
                  <p className="text-white/70 text-xs font-medium uppercase tracking-wider mb-1">Crops Saved</p>
                  <p className="text-white text-2xl font-black">50M+</p>
                </div>
              </div>
            </div>
          </div>

          {/* Bottom Text Area */}
          <div className="mt-auto">
            <div className="w-16 h-16 rounded-2xl mb-8 bg-white/10 backdrop-blur-xl border border-white/20 p-1.5 shadow-[0_8px_32px_rgba(0,0,0,0.3)] overflow-hidden">
              <img src="/logo.png" alt="Lumina Logo" className="w-full h-full object-cover rounded-xl" />
            </div>
            <h2 className="text-[42px] font-black text-white mb-6 leading-[1.1] tracking-tight">
              Protecting crops,<br/>
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-emerald-300 to-teal-200">
                empowering farmers.
              </span>
            </h2>
            <p className="text-emerald-50/80 text-[17px] max-w-[420px] leading-relaxed font-light">
              Advanced AI disease detection, real-time analytics, and seamless coordination to monitor the health of crops across Sri Lanka.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
