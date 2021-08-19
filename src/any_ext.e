note
	description: "Extension for ANY"

deferred class
	ANY_EXT

inherit
	ANY

feature -- Basic Operations

	out_JSON: STRING_32
			-- Current formatted as JSON
		do
			Result := out_JSON_v (Current)
		end

	out_JSON_v (v: ANY): STRING_32
			--
		do
			Result := ser.to_json (v).representation
		end

	ser: JSON_SERIALIZATION
			-- A smart serialization resource.
		do
			Result := (create {JSON_SERIALIZATION_FACTORY}).smart_serialization
			Result.context.register_deserializer (create {LIST_JSON_DESERIALIZER [ANY]}, {like Current})
		end

	out_items: STRING
		do
			check attached {ANY} Current as al_v then
				Result := out_items_v (al_v)
			end
		end

	out_items_v (v: ANY): STRING
			--
		do
			create Result.make_empty
			if attached {ITERABLE [ANY]} v as al_iterable and then
				attached al_iterable.new_cursor as c
			then
				from

				until
					c.after
				loop
					if attached {STRING} c.item as al_item then
						Result.append_string_general (al_item)
					elseif attached {STRING_32} c.item as al_item then
						Result.append_string_general (al_item)
					elseif attached {DATE} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {DATE_TIME} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {INTEGER} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {INTEGER_16} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {INTEGER_32} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {INTEGER_64} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {REAL} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {REAL_32} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {REAL_64} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {CHARACTER} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {CHARACTER_32} c.item as al_item then
						Result.append_string_general (al_item.out)
					elseif attached {BOOLEAN} c.item as al_item then
						Result.append_string_general (al_item.out)
					else
						Result.append_string_general ("Unknown type" + c.item.generating_type)
					end
					Result.append_character (',')
					c.forth
				end
				If Result.count > 1 then
					Result.remove_tail (1)
				end
				Result.prepend_character ('[')
				Result.append_character (']')
			end
		end

	out_log: STRING
			-- Output log-friendly reference to `generating_type' of Current.
		do
			Result := "{" + Generating_type + "}:"
		end

end
