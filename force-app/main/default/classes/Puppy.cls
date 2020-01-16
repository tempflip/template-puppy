public with sharing class Puppy {
    
    static Pattern MARK_PATTERN = Pattern.compile('.+?\\{\\{(.+?)\\}\\}.+');
    static Pattern EACH_PATTERN = Pattern.compile('\\{\\{#each.+?(.+?)\\}\\}(.+?)\\{\\{/each\\}\\}');
    
    
    static Pattern BLOCK_PATTERN = Pattern.compile('(.+?)(\\{\\{#(each|block).+?/(each|block)\\}\\})(.+)');

    Interface IBlock {
        
    }

    public class Block implements IBlock {
        public String body;
        public IBlock[] childrenBlockList;
        private String[] markList;

        public Block(String html) {
            this.parseBlocks(html);
        }

        private void parseBlocks(String htmlParam) {

            String html = htmlParam.replaceAll('\r\n|\n|\r',' ');
            this.markList = new String[]{};
            this.childrenBlockList = new IBlock[]{};

            system.debug('>>>> ' + html);
            Matcher m = BLOCK_PATTERN.matcher(html);


            // block parsing part
            ////////////////////////////////
            this.body = '';
            Integer blockCounter = 0;
            String htmlEnd;
            Boolean groupMatched = false;
            while (m.matches()) {
                groupMatched = true;
                this.childrenBlockList.add(blockFactory(m.group(2)));
                html = m.group(5);

                // system.assert(false, m.group(1) + ' >2|| ' + m.group(2) + ' >3|| ' + m.group(3) + ' >4|| ' + m.group(4) + ' >5|| ' + m.group(5));

                this.body = this.body + m.group(1)
                            + '{### BLOCK N ' + blockCounter + ' }'
                            ;
                
                htmlEnd = m.group(5);

                // next step
                m = BLOCK_PATTERN.matcher(html);
                // htmlEnd = m.group(m.groupCount()-1);

                blockCounter += 1;
            }
            this.body = this.body + htmlEnd;
            
            if (!groupMatched) {
                this.body = htmlParam;
            }

        }
    }

    public class BlockEach implements IBlock {
        // public String body;
        public String varName;
        public Block bodyBlock;

        public BlockEach(String html) {
            Matcher m = EACH_PATTERN.matcher(html);
            if (m.matches()) {
                this.varName = m.group(1);
                this.bodyBlock = new Block(m.group(2));                
            } else {
                system.assert(false, 'BlockEach error!');
            }
        }
    }

    public static IBlock blockFactory(String html) {
        Matcher m = EACH_PATTERN.matcher(html);
        system.debug('!!!!! ' + html);
        if (m.matches()) {
            return new BlockEach(html);
        } else {
            return null;
        }
    }
}
