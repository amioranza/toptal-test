test("DBUSER env var not set", () => {
  expect(process.env.DBUSER).toEqual(undefined);
});

test("DB env var not set", () => {
  expect(process.env.DB).toEqual(undefined);
});
