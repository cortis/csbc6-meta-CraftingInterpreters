#include "common.h"
#include "chunk.h"
#include "debug.h"
#include "vm.h"

int main(int argc, const char* argv[]) {
    initVM();
    
    Chunk chunk;
    initChunk(&chunk);

    int constant = addConstant(&chunk, 1.2);
    writeChunk(&chunk, OP_CONSTANT, 123);
    writeChunk(&chunk, constant, 123);
    writeChunk(&chunk, OP_NEGATE, 123);

    writeChunk(&chunk, OP_RETURN, 123);

    // Cortis: I disabled this line, because it just double traces
    // the content, but as far as I can tell the book doesn't disable it
    // Leaving it here for now so that, if needed I can easily bring it back
    // but will probably delete soon.
    //    disassembleChunk(&chunk, "test chunk");
    
    interpret(&chunk);
    freeVM();
    freeChunk(&chunk);
    return 0;
}
