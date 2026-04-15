import { memo, useCallback } from 'react';
import { Sparkles } from 'lucide-react';
import { cn } from '~/utils';
import { useChatFormContext } from '~/Providers';

interface FollowUpSuggestionsProps {
  messageId: string;
  isLatestMessage: boolean;
  isCreatedByUser: boolean;
}

const FollowUpSuggestions = memo(
  ({ messageId, isLatestMessage, isCreatedByUser }: FollowUpSuggestionsProps) => {
    // Use React Hook Form's setValue for stable reference and proper form state management
    const { setValue } = useChatFormContext();

    // Default follow-up suggestions
    const suggestions = [
      'Can you explain this in more detail?',
      'What are some examples?',
      'How does this work in practice?',
      'Are there any alternatives?',
    ];

    const handleSuggestionClick = useCallback(
      (suggestion: string) => {
        // Use React Hook Form's setValue to update form state properly
        setValue('text', suggestion, { shouldValidate: true });
        
        // Focus textarea and move cursor to end
        const textarea = document.getElementById('prompt-textarea') as HTMLTextAreaElement;
        if (textarea) {
          textarea.focus();
          textarea.setSelectionRange(suggestion.length, suggestion.length);
        }
      },
      [setValue],
    );

    // Conditional return AFTER hooks to maintain stable hook ordering
    if (isCreatedByUser || !isLatestMessage) {
      return null;
    }

    return (
      <div className="mt-3 flex flex-wrap gap-2">
        <div className="flex items-center gap-1.5 text-xs text-text-secondary">
          <Sparkles className="h-3.5 w-3.5" />
          <span className="font-medium">Follow-up:</span>
        </div>
        {suggestions.map((suggestion, index) => (
          <button
            key={`${messageId}-suggestion-${index}`}
            onClick={() => handleSuggestionClick(suggestion)}
            className={cn(
              'group relative inline-flex items-center gap-1.5 rounded-full border px-3 py-1.5 text-xs font-medium transition-all duration-200',
              'border-border-medium bg-surface-primary text-text-primary',
              'hover:border-border-heavy hover:bg-surface-secondary hover:shadow-sm',
              'focus:outline-none focus:ring-2 focus:ring-border-xheavy focus:ring-offset-1',
              'active:scale-95',
            )}
            type="button"
            aria-label={`Ask: ${suggestion}`}
          >
            <span className="relative">{suggestion}</span>
            <div
              className={cn(
                'absolute inset-0 rounded-full opacity-0 transition-opacity duration-200',
                'bg-gradient-to-r from-blue-500/10 to-purple-500/10',
                'group-hover:opacity-100',
              )}
            />
          </button>
        ))}
      </div>
    );
  },
);

FollowUpSuggestions.displayName = 'FollowUpSuggestions';

export default FollowUpSuggestions;
