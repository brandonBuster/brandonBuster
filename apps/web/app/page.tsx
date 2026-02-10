import Link from "next/link";

export default function Home() {
  return (
    <main>
      <h1>Brandon Buster</h1>
      <p>Platform, Data, Infrastructure.</p>
      <nav>
        <Link href="/contact">Contact</Link>
      </nav>
    </main>
  );
}
