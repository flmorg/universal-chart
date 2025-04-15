import $RefParser from "@apidevtools/json-schema-ref-parser";
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// Get the directory name of the current module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

try {
    // read schema from file
    const mySchema = JSON.parse(fs.readFileSync(path.join(__dirname, 'schemas/main.schema.json'), 'utf8'));

    // dereference
    const dereferencedSchema = await $RefParser.dereference(mySchema);

    // write schema to file
    fs.writeFileSync(path.join(__dirname, 'values.schema.json'), JSON.stringify(dereferencedSchema, null, 2));
    console.log('Schema successfully dereferenced and written to values.schema.json');
} catch (err) {
    console.error('Error:', err);
}