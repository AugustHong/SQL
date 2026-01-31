 SET IDENTITY_INSERT [dbo].[Test] ON   /*  開 */
  insert into Test (id, text, value) values (2, N'bbb', 222);
  SET IDENTITY_INSERT [dbo].[Test] OFF  /*  關 */