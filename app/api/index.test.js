test("DBUSER env var not set", () => {
  expect(process.env.DBUSER).toEqual(undefined);
});

test("DB env var not set", () => {
  expect(process.env.DB).toEqual(undefined);
});

test("PORT env var not set", () => {
  expect(process.env.PORT).toEqual(undefined);
});

test("DBPASS env var not set", () => {
  expect(process.env.DBPASS).toEqual(undefined);
});

test("DBHOST env var not set", () => {
  expect(process.env.DBHOST).toEqual(undefined);
});

test("DBPORT env var not set", () => {
  expect(process.env.DBPORT).toEqual(undefined);
});
