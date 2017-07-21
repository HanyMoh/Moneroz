Person.delete_all
Person.create(id: 1, code: 1, name: 'عميل نقدى', person_type: 1)
Person.create(id: 2, code: 1, name: 'المعرض', person_type: 3)

Unit.delete_all
units = Unit.create([
    { id: 1, name: 'وحدة' },
    { id: 2, name: 'قطعة' }
  ])
