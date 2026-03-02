import OpenAI from "openai";

const client = new OpenAI({
    apiKey: "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",
    baseURL: "https://openrouter.ai/api/v1"
});

export async function chatSession(content) {
    const response = await client.chat.completions.create({
        model: "tngtech/tng-r1t-chimera:free",
        messages: [
            {
                role: "system",
                content: "You are a helpful study assistant. Start directly with the main point."
            },
            {
                role: "user",
                content: content
            }
        ],
        temperature: 0.7,
        max_tokens: 1500,
        stream: false
    });

    return response.choices[0].message.content;
}