import $RefParser from "@apidevtools/json-schema-ref-parser";
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// Get the directory name of the current module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

try {
    // read schema from file
    const mySchema = JSON.parse(fs.readFileSync(path.join(__dirname, 'main.schema.json'), 'utf8'));

    // Create a new parser instance
    const parser = new $RefParser();

    // Parse the schema with options
    const parsedSchema = await parser.parse(mySchema, {
        // This tells the parser to look for files in the current directory
        resolve: {
            file: {
                // This function handles file references
                read: (file) => {
                    // Handle both relative and absolute paths
                    let filePath;
                    if (path.isAbsolute(file)) {
                        filePath = file;
                    } else {
                        filePath = path.join(__dirname, file);
                    }
                    
                    // Check if file exists
                    if (!fs.existsSync(filePath)) {
                        throw new Error(`File not found: ${filePath}`);
                    }
                    
                    return fs.readFileSync(filePath, 'utf8');
                }
            }
        }
    });

    // Dereference the schema
    const dereferencedSchema = await parser.dereference(parsedSchema, {
        // This tells the parser to use the $id field for resolving references
        dereference: {
            circular: true,
            // This is important - it tells the parser to use the $id field
            // for resolving references instead of looking for tokens
            use$id: true
        }
    });

    // write schema to file
    fs.writeFileSync('../values.schema.json', JSON.stringify(dereferencedSchema, null, 2));
    console.log('Schema successfully dereferenced and written to values.schema.json');
} catch (err) {
    console.error('Error:', err);
}