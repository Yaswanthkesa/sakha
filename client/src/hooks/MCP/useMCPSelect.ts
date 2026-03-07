import { useCallback, useEffect, useMemo } from 'react';
import { useAtom } from 'jotai';
import { useRecoilState } from 'recoil';
import { Constants } from 'librechat-data-provider';
import { ephemeralAgentByConvoId, mcpPinnedAtom } from '~/store';
import { useGetStartupConfig } from '~/data-provider';

export function useMCPSelect({ conversationId }: { conversationId?: string | null }) {
  const key = conversationId ?? Constants.NEW_CONVO;

  const { data: startupConfig } = useGetStartupConfig();
  const [isPinned, setIsPinned] = useAtom(mcpPinnedAtom);
  const [, setEphemeralAgent] = useRecoilState(ephemeralAgentByConvoId(key));

  // Compute all configured servers to be permanently active
  const allServers = useMemo(() => {
    if (startupConfig?.mcpServers) {
      return Object.entries(startupConfig.mcpServers)
        .filter(([, config]) => config.chatMenu !== false)
        .map(([name]) => name)
        .sort();
    }
    return [];
  }, [startupConfig]);

  // Permanently force the ephemeral agent to use ALL servers
  useEffect(() => {
    if (allServers.length > 0) {
      setEphemeralAgent((prev) => {
        // Prevent infinite re-renders by checking if it's already set correctly
        const same =
          prev?.mcp &&
          prev.mcp.length === allServers.length &&
          prev.mcp.slice().sort().every((v, i) => v === allServers[i]);

        if (same) {
          return prev;
        }

        return { ...(prev ?? {}), mcp: allServers };
      });
    }
  }, [allServers, setEphemeralAgent]);

  /** Deliberately swallows clicks so servers can NEVER be unselected */
  const setMCPValues = useCallback(() => {
    // Locked on purpose
  }, []);

  return {
    isPinned,
    mcpValues: allServers,
    
    setIsPinned,
    setMCPValues,
  };
}
