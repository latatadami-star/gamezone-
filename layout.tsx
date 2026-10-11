import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title: 'GAME ZONE | Play. Compete. Repeat.', description: 'Book your PS3 and PS4 gaming session at GAME ZONE.' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="en"><body>{children}</body></html>; }
