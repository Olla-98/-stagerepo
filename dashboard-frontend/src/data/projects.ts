import type { Project } from '../types'

export const projects: Project[] = [
  {
    id: 'website',
    name: 'Website ontwikkeling',
    description: 'Een nieuwe website met een toegankelijke en overzichtelijke ervaring.',
    status: 'Actief',
    budget: 100,
    recorded: 65,
    updatedAt: '7 oktober 2026',
    phases: [
      { name: 'Ontwerp', hours: 18 },
      { name: 'Frontend', hours: 32 },
      { name: 'Afronding', hours: 15 },
    ],
  },
  {
    id: 'webshop',
    name: 'Webshop',
    description: 'Een webshop met productoverzicht en een eenvoudige bestelervaring.',
    status: 'Actief',
    budget: 200,
    recorded: 120,
    updatedAt: '6 oktober 2026',
    phases: [
      { name: 'Ontwerp', hours: 24 },
      { name: 'Frontend', hours: 54 },
      { name: 'Koppelingen', hours: 42 },
    ],
  },
  {
    id: 'klantportaal',
    name: 'Klantportaal',
    description: 'Een centrale plek voor klantinformatie en projectupdates.',
    status: 'On hold',
    budget: 80,
    recorded: 36,
    updatedAt: '30 september 2026',
    phases: [
      { name: 'Onderzoek', hours: 12 },
      { name: 'Ontwerp', hours: 16 },
      { name: 'Uitwerking', hours: 8 },
    ],
  },
  {
    id: 'huisstijl',
    name: 'Huisstijl vernieuwing',
    description: 'Een herkenbare visuele basis voor de organisatie.',
    status: 'Afgerond',
    budget: 60,
    recorded: 56,
    updatedAt: '18 september 2026',
    phases: [
      { name: 'Onderzoek', hours: 12 },
      { name: 'Ontwerp', hours: 30 },
      { name: 'Oplevering', hours: 14 },
    ],
  },
]
