#!/usr/bin/env gt

--[[
  Copyright (c) 2014 Sascha Steinbiss <ss34@sanger.ac.uk>
  Copyright (c) 2014 Genome Research Ltd

  Permission to use, copy, modify, and distribute this software for any
  purpose with or without fee is hereby granted, provided that the above
  copyright notice and this permission notice appear in all copies.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
]]

function usage()
  io.stderr:write("Transfer GO annotations from orthologs in "
                  .. "reference genomes.\n")
  io.stderr:write(string.format("Usage: %s <target GFF3_file> "
                                .. "<source GAF file> <db> <taxonid>\n", arg[0]))
  os.exit(1)
end

if #arg < 4 then
  usage()
end

db = arg[3]
taxonid = arg[4]

package.path = gt.script_dir .. "/?.lua;" .. package.path
require("lib")

annotate_vis = gt.custom_visitor_new()
function annotate_vis:visit_feature(fn)
  if fn:get_type() == "polypeptide" then
    orths = fn:get_attribute("orthologous_to")
    nof_orths = 0
    if orths then
      local gos = {}
      for _,orth in ipairs(split(orths, ",")) do
        nof_orths = nof_orths + 1
        orth = orth:gsub("GeneDB:","")
        if self.store[orth] then
          for _,item in ipairs(self.store[orth]) do
            if is_experimental(item.evidence) then
              prod = gff3_extract_structure(fn:get_attribute("product"))
              if not gos[item.goid] then
                gos[item.goid] = {}
              end
              table.insert(gos[item.goid], {orthid=orth, qual=item.qual,
                           aspect=item.aspect})
            end
          end
        end
      end
      for go, orthlist in pairs(gos) do
        local orthids = {}
        for _,v in ipairs(orthlist) do
          table.insert(orthids, "GeneDB:"..v.orthid)
        end
        print(table.concat({tostring(db),
                                  fn:get_attribute("ID"):split("%.")[1],
                                  fn:get_attribute("ID"):split("%.")[1],
                                  orthlist[1].qual,
                                  go,
                                  "GO_REF:0000101",
                                  "ISO",
                                  table.concat(orthids, "|"),
                                  orthlist[1].aspect,
                                  tostring(prod[1].term),
                                  "",
                                  "gene",
                                  "taxon:" .. tostring(taxonid),
                                  os.date("%Y%m%d"),
                                  tostring(db)
                                 }, "\t"))
      end
    end
  end
  return 0
end

-- get annotations from reference(s)
store = {}
for l in io.lines(arg[2]) do
  local db,dbid,dbobj,qual,goid,dbref,evidence,withfrom,aspect,dbobjname,
    dbobjsyn,dbobjtype,taxon,data,assignedby = unpack(split(l, '\t'))
  if not store[dbid] then
    store[dbid] = {}
  end
  table.insert(store[dbid], {db=db, dbid=dbid, qual=qual, goid=goid,
                             dbref=dbref, evidence=evidence, withfrom=withfrom,
                             aspect=aspect, dbobjname=dbobjname,
                             dbobjsyn=dbobjsyn, dbobjtype=dbobjtype,
                             taxon=taxon, data=data, assignedby=assignedby})
end

visitor_stream = visitor_stream_new(gt.gff3_in_stream_new_sorted(arg[1]),
                                    annotate_vis)
annotate_vis.store = store
out_stream = visitor_stream
local gn = out_stream:next_tree()
while (gn) do
  gn = out_stream:next_tree()
end
