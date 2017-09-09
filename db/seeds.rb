User.delete_all
User.create(id: 1, user_name: 'admin', password:'123456', password_confirmation:'123456', admin: true, email: 'hanymoh@msn.com', active: true)

Person.delete_all
Person.create(id: 1, code: 1, name: 'عميل نقدى', person_type: 1)
Person.create(id: 2, code: 1, name: 'المعرض', person_type: 3)
Person.create(id: 3, code: 1, name: 'الخزينة الرئيسية', person_type: 4)

Unit.delete_all
units = Unit.create([
    { id: 1, code: 1, name: 'وحدة' },
    { id: 2, code: 2, name: 'قطعة' }
  ])
