## concepts-artboards

`concepts-artboards` is a Ruby script to convert [Concepts](https://concepts.app/en/) SVG exports into combined and individual PDF files.

This is an initial release; it has only been tested for my use cases. I am a math professor. From an infinite Concepts canvas, I use `concepts-artboards` to create math notes for personal use and for teaching, and to spawn PDF illustrations for a LaTex document such as a book project.

There is a Reddit discussion of this script [here](https://www.reddit.com/r/ConceptsApp/comments/lwl8r5/conceptsartboards_a_ruby_script_for_converting/).

### Usage
    concepts-artboards -i svg -d dir [-o pdf] [options]

    Required arguments:

        -i, --input      input SVG file
        -d, --directory  scratch directory for intermediate files

    Output options:

        -o, --output     output PDF file
        -l, --labels     name of optional Labels layer
        -p, --pdf        keep individual artboard PDF files
        -s, --svg        keep individual artboard SVG files

    Other options:

        -h, --help       
        -v, --version    

        -a, --artboards  name of Artboards layer (default: Artboards)
        -r, --remove     other layers to remove from output
        -q, --quantum    points multiple for rounding artboards (default: 8)


`concepts-artboards` looks for rectangles in an Artboards layer to define artboards for output, and looks for text in an optional Labels layer to name these output files. These layers are then deleted from the output. Any text in the Labels layer that is positioned within an artboard rectangle names that artboard; artboards are otherwise numbered sequentially left to right, row by row. This is also the output order (included the named artboards) for the combined PDF file.

The individual SVG and PDF artboard files can be kept or discarded. If these files are discarded, and `concepts-artboards` created the scratch directory, then it will also remove this directory. The `--output` option merges these individual files into a single document.

For example,

    concepts-artboards \
      --input canvas.svg \
      --output canvas.pdf \
      --directory scratch \
      --pdf \

will convert all artboards in `canvas.svg` into the combined output file `canvas.pdf`, keeping the intermediate PDF files.

`concepts-artboards` requires a Ruby installation. It uses the [Ox](http://www.ohler.com/ox/) gem; one will need to install Ox via the command `gem install ox`. Ox is a lightweight, fast XML library, and this script provides a good example of its use. `concepts-artboards` also calls two command line programs that can be installed on a Mac using [homebrew](https://brew.sh/): `svg2pdf` and `gs`.

The code attempts to degenerate gracefully. One is advised to use rectangles to define artboards, but any stroke will result in its bounding box. One is advised to arrange artboards in an orderly fashion, but the code will make reasonable choices for randomly placed artboards. A certain tolerance is necessary here, because users shouldn't be required to place rectangles exactly, and doing so is tricky in Concepts.

I recommend scaling Concepts canvases using points, bearing in mind that Concepts points are 132 per inch, not 72 per inch as is standard in many graphics applications. The `concepts-artboards` call to `svg2pdf` is scaled based on this convention. When one does rely on Concepts to output directly to PDF, points is the only predictable unit for obtaining reliably scaled PDF files.
### Examples

The `Examples` directory contains a Concepts native file `Test.concept` that one can import back into Concepts to confirm my description of using layers to define artboards. `Test-Canvas.pdf` has been exported directly by Concepts, and gives a view of the artboard layout. `Test.svg` is the SVG file exported from this canvas, and `Test.pdf` is the output PDF file containing a page per artboard. The `PDF` directory contains an output PDF file for each individual artboard. One can run the shell script `Test.sh` to recreate these output files.

`Counting.pdf` is a production example, lecture notes for a math class. `Counting-Canvas.pdf` has been exported directly by Concepts, and gives a view of the artboard layout.

### Discussion

Concepts is my favorite iPad app for digital sketching. During the pandemic, many of my colleagues have been teaching via Zoom using [Notability](https://www.gingerlabs.com/). One easily gets frustrated with Notability's limited support for algorithmic drawing. At the same time, Notability is friction-free for what it does well. Nearly every advanced drawing app botches freehand drawing, and one's handwriting suffers. One can reject half the app candidates out there by trying to dot an "i".

Concepts is the most powerful app I know that gets freehand drawing right, with little fuss. Its capabilities are intoxicating. At the same time, I could write a book-length treatise on what frustrates me about Concepts. For one example of many, its "snap to grid" is nearly unusable. Nevertheless, until I write my own app (a drawing editor that is completely programmable using drawings, akin to how Emacs relies on Lisp), Concepts is my drawing app of choice.

Concepts supports an infinite canvas. Indeed, an infinite canvas is the idiomatic way to use Concepts. It has no mechanism for exporting multiple PDF files from a single canvas, and one really doesn't want to work with multiple canvases: Carefully tuned Tool Wheel customizations are per canvas, and copy and paste between canvases doesn't respect layer identities. However, Concepts can export an entire canvas as a single SVG file.

While not all Concepts constructs can be represented as SVG line art, I'm happy to confine myself to the constructs that can. Anyone who has delved into the PDF format knows that it consists of many geological layers of unwieldy specifications,  with no way to validate a correct file (if one must, it is most rewarding to code in the geologically earliest layers). The SVG format is by comparison a thing of beauty, easily manipulated. There are open source command line programs such as `svg2pdf` that take care of clipping all art that won't show in the output page. So splitting an SVG file into multiple PDF pages is trivial: All one has to do is rewrite the header attributes defining the output page, and convert to PDF. Lather, rinse, repeat. This is what `concepts-artboards` does. Most of the work is parsing the artboard definitions, and deciding the file names and page order. It's a short script.

If various of us start to use Concepts to output multiple PDF pages, they'll likely incorporate a feature that supports this. They're very responsive to feedback. My concern over how Concepts might implement this is cultural: In an alternate universe I'd be a language designer, and I measure all software by how it fares as a programming language design. I respect the idea of a "first class citizen" in a programming language. In a drawing program, only the drawings themselves are first class citizens; preference handling is clumsy because preferences aren't represented by drawings. `concepts-artboards` represents preferences by drawings, so anything is possible.

An exception that comes to mind is desktop Adobe Illustrator's ability to convert rectangles to artboards. That was the inspiration for my approach here.

Concepts did their part by exporting to SVG. Now it's on us. I'm in conversations with other mathematicians over how this script could evolve. One could draw a tree/forest/graph of idea artboards, as one's thinking evolves, and have this script output the graph depth-first?

My college roommate had his life changed by meeting Ted Nelson, a hypertext pioneer who coined the term. The PDF format would support "hyperdrawings" if we can figure out how to say in a drawing what we mean by this. Certainly, a drawing-based programming language would need a version of hypertext, to support something like an APL workspace. Please get in touch if you have ideas for this.

